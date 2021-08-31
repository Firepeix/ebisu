import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputFormDecorator {
  InputDecoration textForm (String? label, String? hint, {bool dense: false}) {
    return InputDecoration(
      border: OutlineInputBorder(),
      hintText: hint ?? '',
      labelText: label ?? '',
      errorStyle: TextStyle(fontSize: 16),
      isDense: true,
      contentPadding: EdgeInsets.fromLTRB(12, !dense ? 20 : 20, 12, !dense ? 12 : 0)
    );
  }

  InputDecoration selectForm (String? label, String? hint) {
    return InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint ?? '',
        labelText: label ?? '',
        isDense: true,
        errorStyle: TextStyle(fontSize: 16),
        contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 9)
    );
  }

  InputDecoration amountForm () {
    return InputDecoration(
        prefix: Text('R\$ '),
        helperStyle: TextStyle(fontSize: 0),
        errorStyle: TextStyle(fontSize: 16),
        contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
        prefixStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.grey)
    );
  }
}
