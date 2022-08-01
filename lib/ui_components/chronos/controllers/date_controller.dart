import 'package:ebisu/ui_components/chronos/controllers/controllers.dart';
import 'package:flutter/material.dart';

class DateController implements Controller{
  final _controller = TextEditingController();

  DateController() {
    _controller.addListener(() {
      final String text = _applyDate(_controller.text.replaceAll(RegExp(r'\D'), ""));

      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  String _applyDate(String rawNumbers) {
    String date = "";
    final lastPos = rawNumbers.length >= 9 ? 8 : rawNumbers.length;
    int pos = 0;
    rawNumbers.substring(0, lastPos).split("").forEach((element) {
      date += element;
      if(pos == 1 || pos == 3) {
        date += "/";
      }
      pos++;
    });
    return date.replaceAll(RegExp(r"\/$"), "");
  }

  String text() {
    return _controller.text;
  }

  DateTime? date() {
    return DateTime.tryParse(_controller.text.split("/").reversed.join("-"));
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  TextEditingController getController() {
    return _controller;
  }
}