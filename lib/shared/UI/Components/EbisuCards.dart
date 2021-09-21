import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  Summary({required this.children, this.padding, this.crossAxisAlignment});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 4,
    child: Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          children: children
      ),
    ),
  );
}

class SimpleCard extends StatelessWidget {
  final Widget child;
  final double? height;
  SimpleCard({required this.child, this.height});

  @override
  Widget build (BuildContext _) => SizedBox(
    height: height,
    width: double.infinity,
    child: Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade400, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: child,
      ),
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

class EbisuDivider extends SummaryDivider {

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

