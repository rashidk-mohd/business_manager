import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../models/leads_model.dart';
import '../../provider/customer_provider.dart';
import '../../provider/leads_provider.dart';
import '../../provider/users.dart';
import '../../utils/color_constants.dart';
import '../../utils/routes.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/leadsCard.dart';
import 'lead_detail_&_Activity_screen.dart';

class LeadScreen1 extends StatefulWidget {
  @override
  State<LeadScreen1> createState() => _LeadScreen1State();
}

class _LeadScreen1State extends State<LeadScreen1> {
  final ScrollController _scrollController = ScrollController();
  bool _scrolling = false;

  var _isLoading = false;
  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<LeadsProvider>(context).fetchAndSetleads(context).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Provider.of<CustomerProvider>(context, listen: false)
        .fetchAndSetCustomers(context);

    Provider.of<Users>(context, listen: false).fetchAndSetUsers(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<LeadsProvider>(context);
    return Scaffold(
      backgroundColor: ColorConstants.backGroundColor,
      appBar: CustomAppBar(
        'LEADS',
        isLead: true,
        leadWidget: IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.homeScreen),
            icon: Icon(Icons.arrow_back_rounded)),
        actionButton: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  iconSize: 35,
                  onPressed: () {
                    Navigator.pushNamed(
                        context, Routes.routeLeadsAddingScreens);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        dragStartBehavior: DragStartBehavior.start,
        controller: _scrollController,
        child: Row(
          children: [
            buildTarget(context, title: 'New', leads: item.newItem,
                onAccept: (data) {
              print("here is new");
              Lead newLead = data;
              item.removeAll(context, data);
              item.newItem.add(data);
              item.updateLeadStatus(
                  context, newLead.id, data, "New", newLead.date);
            }),
            buildTarget(context, title: "Qualified", leads: item.qualifiedItem,
                onAccept: (data) {
              Lead newLead = data;
              item.removeAll(context, data);
              item.qualifiedItem.add(data);
              item.updateLeadStatus(
                  context, newLead.id, data, "Qualified", newLead.date);
            }),
            buildTarget(context,
                title: "Proposition",
                leads: item.propositionItem, onAccept: (data) {
              Lead newLead = data;
              item.removeAll(context, data);
              setState(() {
                newLead.status;
              });
              item.propositionItem.add(data);
              item.updateLeadStatus(
                  context, newLead.id, data, "Proposition", newLead.date);
            }),
            buildTarget(context, title: "Won", leads: item.wonItem,
                onAccept: (data) {
              Lead newLead = data;
              item.removeAll(context, data);

              item.wonItem.add(data);
              item.updateLeadStatus(
                  context, newLead.id, data, "Won", newLead.date);
            }),
          ],
        ),
      ),
    );
  }

  Widget buildTarget(
    BuildContext context, {
    @required String? title,
    @required List<Lead>? leads,
    @required DragTargetAccept? onAccept,
  }) {
    final mediaSize = MediaQuery.of(context).size;
    final width = mediaSize.width;
    final height = mediaSize.height;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
      padding: EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 8),
      width: width * .69,
      height: MediaQuery.of(context).size.height * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 5.0),
            blurRadius: 15.0,
            spreadRadius: 2.0,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title!,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.headline3,
                )
              ],
            ),
          ),
          Expanded(
            child: DragTarget(
              builder: (context, candidateData, rejectedData) => Container(
                height: MediaQuery.of(context).size.height * .8,
                width: width * .8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...leads!
                          .map((lead) => InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => leadDetailScreen(
                                              id: lead.id,
                                              title: lead.title,
                                              customer: lead.customer,
                                              revenue: lead.revenue,
                                              salesperson: lead.salesperson,
                                              details: lead.details,
                                            ))),
                                child: Draggable(
                                  onDragUpdate: (details) {
                                    scrollList(details.globalPosition.dx);
                                  },
                                  data: lead,
                                  feedback: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      child: LeadsCard(lead, true)),
                                  child: LeadsCard(lead, false),
                                  childWhenDragging: Container(),
                                ),
                              ))
                          .toList()
                    ],
                  ),
                ),
              ),
              onAccept: (data) => onAccept!(data),
              onWillAccept: (data) => true,
            ),
          )
        ],
      ),
    );
  }

  final int _scrollAreaSize = 25;
  final double _overDragMin = 5.0;
  final double _overDragMax = 20.0;
  final double _overDragCoefficient = 0.09;
  void scrollList(double position) async {
    double? newOffset;
    var rb = context.findRenderObject()!;
    late Size size;
    if (rb is RenderBox)
      size = rb.size;
    else if (rb is RenderSliver) size = rb.paintBounds.size;

    var topLeftOffset = localToGlobal(rb, Offset.zero);
    var bottomRightOffset = localToGlobal(rb, size.bottomRight(Offset.zero));
    var directionality = Directionality.of(context);
    if (directionality == TextDirection.ltr) {
      newOffset =
          _scrollListHorizontalLtr(topLeftOffset, bottomRightOffset, position);
    } else {
      newOffset =
          _scrollListHorizontalRtl(topLeftOffset, bottomRightOffset, position);
    }

    if (newOffset != null) {
      _scrolling = true;
      await _scrollController.animateTo(newOffset,
          duration: Duration(milliseconds: 30), curve: Curves.bounceIn);
      _scrolling = false;
      // if (_pointerDown) _scrollList();
    }
  }

  double? _scrollListHorizontalLtr(
      Offset topLeftOffset, Offset bottomRightOffset, double position) {
    double left = topLeftOffset.dx;
    double right = bottomRightOffset.dx;
    double? newOffset;

    var pointerXPosition = position;
    var scrollController = _scrollController;
    if (scrollController != null && pointerXPosition != null) {
      if (pointerXPosition < (left + _scrollAreaSize) &&
          scrollController.position.pixels >
              scrollController.position.minScrollExtent) {
        // scrolling toward minScrollExtent
        final overDrag = min(
            (left + _scrollAreaSize) - pointerXPosition + _overDragMin,
            _overDragMax);
        newOffset = max(scrollController.position.minScrollExtent,
            scrollController.position.pixels - overDrag / _overDragCoefficient);
      } else if (pointerXPosition > (right - _scrollAreaSize) &&
          scrollController.position.pixels <
              scrollController.position.maxScrollExtent) {
        // scrolling toward maxScrollExtent
        final overDrag = min(
            pointerXPosition - (right - _scrollAreaSize) + _overDragMin,
            _overDragMax);
        newOffset = min(scrollController.position.maxScrollExtent,
            scrollController.position.pixels + overDrag / _overDragCoefficient);
      }
    }

    return newOffset;
  }

  double? _scrollListHorizontalRtl(
      Offset topLeftOffset, Offset bottomRightOffset, double position) {
    double left = topLeftOffset.dx;
    double right = bottomRightOffset.dx;
    double? newOffset;

    var pointerXPosition = position;
    var scrollController = _scrollController;
    if (scrollController != null && pointerXPosition != null) {
      if (pointerXPosition < (left + _scrollAreaSize) &&
          scrollController.position.pixels <
              scrollController.position.maxScrollExtent) {
        // scrolling toward maxScrollExtent
        final overDrag = min(
            (left + _scrollAreaSize) - pointerXPosition + _overDragMin,
            _overDragMax);
        newOffset = min(scrollController.position.maxScrollExtent,
            scrollController.position.pixels + overDrag / _overDragCoefficient);
      } else if (pointerXPosition > (right - _scrollAreaSize) &&
          scrollController.position.pixels >
              scrollController.position.minScrollExtent) {
        // scrolling toward minScrollExtent
        final overDrag = min(
            pointerXPosition - (right - _scrollAreaSize) + _overDragMin,
            _overDragMax);
        newOffset = max(scrollController.position.minScrollExtent,
            scrollController.position.pixels - overDrag / _overDragCoefficient);
      }
    }

    return newOffset;
  }

  static Offset localToGlobal(RenderObject object, Offset point,
      {RenderObject? ancestor}) {
    return MatrixUtils.transformPoint(object.getTransformTo(ancestor), point);
  }
}
