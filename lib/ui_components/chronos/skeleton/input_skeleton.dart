import 'package:flutter/material.dart';

class InputSkeleton extends StatelessWidget {
  final bool expanded;
  final double width;

  const InputSkeleton({Key? key, this.expanded = false, this.width = 351}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expanded ? double.infinity : width,
      height: 51,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        shape: BoxShape.rectangle,
      ),
    );
  }
}
