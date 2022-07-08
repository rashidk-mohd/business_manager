import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final Size preferredSize;
  final List<Widget>? actionButton;
  bool? centerTitle;
  final bool isLead;
  final Widget? leadWidget;
  CustomAppBar(this.title,
      {Key? key,
      this.actionButton,
      this.centerTitle,
      this.isLead = false,
      this.leadWidget})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      title: Text(
        title!,
        style: Theme.of(context).textTheme.headline1,
      ),
      leading: isLead == true ? leadWidget : null,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorConstants.appBarGradientColor1,
              ColorConstants.appBarGradientColor2,
              ColorConstants.appBarGradientColor3,
              ColorConstants.appBarGradientColor4
            ],
          ),
        ),
      ),
      actions: actionButton,
    );
  }
}
