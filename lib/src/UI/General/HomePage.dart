import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class HomePage extends AbstractPage {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("HomePage")
      ],
    );
  }
}