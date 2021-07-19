import 'package:flutter/material.dart';

class InputFormDecorator {
  InputDecoration textForm (String? label, String? hint) {
    return InputDecoration(
      border: OutlineInputBorder(),
      hintText: hint ?? '',
      labelText: label ?? '',
      isDense: true
    );
  }
}