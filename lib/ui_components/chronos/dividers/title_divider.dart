import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:flutter/material.dart';

class TitleDivider extends StatelessWidget {
  final int length;
  const TitleDivider({Key? key, this.length = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Expanded(
        flex: length,
        child: Container(
          height: 3,
          decoration: const BoxDecoration(
            color: EColor.black,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
      Expanded(
        flex: 10,
        child: Container(
          height: 3,
          decoration: BoxDecoration(
            color: EColor.grey.shade300,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
            shape: BoxShape.rectangle,
          ),
        ),
      )
    ],
  );
}
