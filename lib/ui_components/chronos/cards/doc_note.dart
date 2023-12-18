import 'package:ebisu/shared/utils/matcher.dart';
import 'package:flutter/material.dart';

enum DocNoteType {
  Success(Color(0xFFA5D6A7), Colors.green),
  Warning(Color(0xFFFFF59D), Colors.yellow),
  Danger(Color(0xFFEF9A9A), Colors.red);

  final Color color;
  final Color borderColor;

  const DocNoteType(this.color, this.borderColor);

  T match<T>({required T success, required T warning, required T danger}) {
    return Matcher.matchWhen(this, {
      Success: success,
      Warning: warning,
      Danger: danger
    });
  }
}

class DocNote extends StatelessWidget {
  final String _title;
  final String _text;
  final DocNoteType _type;

  const DocNote(this._title, this._text, this._type, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)), color: _type.borderColor
      ),
      child: Card(
        margin: EdgeInsets.only(right: 5, left: 5),
        color: _type.color,
        shape: Border.symmetric(vertical: BorderSide(width: 2, color: _type.borderColor)),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 15, left: 15, right: 15), child: Text(_title, style: TextStyle(fontWeight: FontWeight.w900),),),
            Padding(padding: EdgeInsets.all(15), child: Text(_text, style: TextStyle(fontWeight: FontWeight.w400)),)
          ],
        ),
      ),
    );
  }
}
