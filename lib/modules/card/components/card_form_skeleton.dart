import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/amount_input.dart';
import 'package:flutter/material.dart';

class CardFormSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(isLoading: true, child: Column(
        children: [
          Container(
            width: 351,
            height: 51,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              shape: BoxShape.rectangle,
            ),
          ),
          Container(
            width: 351,
            height: 51,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              shape: BoxShape.rectangle,
            ),
          ),
          Container(
            width: 351,
            height: 51,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              shape: BoxShape.rectangle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: AmountInput(
              enabled: false,
              value: 0,
            ),
          )
        ],
      )),
    );
  }
}
