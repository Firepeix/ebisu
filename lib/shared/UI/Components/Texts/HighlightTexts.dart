import 'package:flutter/material.dart';

class HighlightedAmountText extends StatelessWidget {
  final String _text;

  HighlightedAmountText(this._text);

  @override
  Widget build(BuildContext context) =>
      Text(_text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.red)
      );
}