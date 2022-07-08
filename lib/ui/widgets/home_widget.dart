import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  final Widget? child;
  bool vertical;
  HomeWidget({
    this.child,
    this.vertical = true,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        //margin:  EdgeInsets.symmetric(horizontal: 15, vertical: vertical ? 35 : 0),
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.secondary,
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.grey,
          //     offset: Offset(0, 5.0),
          //     blurRadius: 15.0,
          //     spreadRadius: 2.0,
          //   )
          //],
        ),
        child: child,
      ),
    );
  }
}
