import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  final List<Widget> children;

  Summary({required this.children});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 4,
    child: Column(
      children: children
    ),
  );
}

class SummarySection extends StatelessWidget {
  final List<Widget> children;

  SummarySection({required this.children});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    ),
  );
}

class SummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 3,
    decoration: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.rectangle,
    ),
  );
}

class VerticalSummaryDivider extends StatelessWidget {
  final double height;

  VerticalSummaryDivider({this.height: 3});

  @override
  Widget build(BuildContext context) => Container(
    width: 3,
    height: height,
    decoration: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.rectangle,
    ),
  );
}

