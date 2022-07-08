import 'package:flutter/material.dart';

class RowText extends StatelessWidget {
  String? keyText;
  String valueText;

  RowText({
    required this.keyText,
    required this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          keyText!,
          softWrap: false,
          style: Theme.of(context).textTheme.headline2,
        ),
        Expanded(
          child: Text(
            valueText,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }
}
