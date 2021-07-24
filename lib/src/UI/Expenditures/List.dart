import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class ListExpenditurePage extends AbstractPage {
  static const PAGE_INDEX = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.paid_outlined, size: 300,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Para fazer!', style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),)
                  ],
                )
              ],
            )
        ),
      ],
    );
  }
}