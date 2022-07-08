import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeCard extends StatelessWidget {
  final Widget? childs;
  void Function(BuildContext ctx)? onPressededit;
  void Function()? onPresseddelete;
  bool visiblEdit;

  void Function()? onTap;
  HomeCard(
      {this.childs,
      this.onPressededit,
      this.onPresseddelete,
      this.onTap,
      this.visiblEdit = true});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(2),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        // dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          if (visiblEdit)
            SlidableAction(
              flex: 1,
              onPressed: onPressededit,
              backgroundColor: const Color(0xFF2182BA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                  context: context,
                  builder: (context) {
                    // borderRadius:
                    // BorderRadius.all(Radius.zero);
                    return AlertDialog(
                      title: Column(
                        children: [
                          const Icon(
                            Icons.delete,
                            size: 80,
                            color: Colors.red,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Are You Sure?',
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ],
                      ),
                      content: const Text(
                        "Are you sure you want to delete this file? you can't undo this actions.",
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: onPresseddelete,
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ],
                        ),
                      ],
                      actionsAlignment: MainAxisAlignment.center,
                    );
                  });
            },
            backgroundColor: const Color(0xFFF23232),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.11,
        width: MediaQuery.of(context).size.width * 1,
        child: InkWell(
          child: Card(
            //  margin: const EdgeInsets.all(10),
            elevation: 3,
            color: Theme.of(context).colorScheme.secondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: childs,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
