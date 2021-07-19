import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class ListExpenditurePage extends AbstractPage {
  static const PAGE_INDEX = 2;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("ListExpenditure")
      ],
    );
  }
}