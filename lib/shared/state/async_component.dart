import 'package:flutter/material.dart';

mixin AsyncComponent<T extends StatefulWidget> implements State<T> {
  updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}