import 'package:flutter/material.dart';

class GeneralCard extends StatelessWidget {
  final Widget child;
  final double? elevation;
  final bool hasOwnPadding;
  static const double padding = 8;

  const GeneralCard({Key? key, required this.child, this.elevation, this.hasOwnPadding = false}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    elevation: elevation ?? 3,
    child: Padding(
      padding: EdgeInsets.all(hasOwnPadding ? 0 : padding),
      child: child,
    ),
  );
}
