import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;

  const Body({Key? key, required this.child, this.horizontalPadding = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.only(top: 20, left: horizontalPadding, right: horizontalPadding),
      child: child,
    ),
  );
}