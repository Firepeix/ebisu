import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/amount_input.dart';
import 'package:ebisu/ui_components/chronos/skeleton/input_skeleton.dart';
import 'package:flutter/material.dart';

class CardFormSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(isLoading: true, child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: InputSkeleton(expanded: true,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(flex: 10, child: InputSkeleton(),),
                Spacer(),
                Expanded(flex: 10, child: InputSkeleton())
              ],
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
