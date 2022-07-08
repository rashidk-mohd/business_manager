import 'package:flutter/material.dart';

class LeadDetailsdWidget extends StatelessWidget {
  final Widget? child;

  LeadDetailsdWidget({
    this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.background,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 2.0,
            )
          ],
        ),
        child: child,
      ),
    );
  }
}
