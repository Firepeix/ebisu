import 'package:flutter/material.dart';

class GeneralCard extends StatelessWidget {
  final Widget child;
  final double? elevation;
  final bool hasOwnPadding;
  static const double padding = 8;

  const GeneralCard({Key? key, required this.child, this.elevation, this.hasOwnPadding = false}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(5)
        )
    ),
    child: Padding(
      padding: EdgeInsets.all(hasOwnPadding ? 0 : padding),
      child: child,
    ),
  );
}
