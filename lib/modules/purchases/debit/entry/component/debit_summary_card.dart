import 'package:ebisu/main.dart';
import 'package:ebisu/modules/card/pages/update_card_page.dart';
import 'package:ebisu/modules/purchases/debit/core/domain/debit_summary.dart';
import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/ui_components/chronos/buttons/transparent_button.dart';
import 'package:ebisu/ui_components/chronos/cards/general_card.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

class DebitSummaryCard extends StatelessWidget {
  final DebitSummary summary;


  const DebitSummaryCard(this.summary, {super.key});

  Padding availableAmount() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Valor Disponível: ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
          MoneyLabel(summary.forecastAmount, size: 21,)
        ],
      ),
    );
  }

  Padding totalAmount() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Ativos Totais: ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
          MoneyLabel(summary.totalAmount, size: 21,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GeneralCard(
      hasOwnPadding: true,
      child: TransparentButton(
              onPressed: () => routeTo(context, UpdateCardPage("1", "asd"), animation: IntoViewAnimation.pop),
          child: Column(
            children: [
              availableAmount(),
              EbisuDivider(),
              totalAmount(),
            ],
          )
      ),
    );
  }
}

class DebitSummaryCardSkeleton extends StatelessWidget {
  const DebitSummaryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(
          isLoading: true,
          child: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                height: 95,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
          )),
    );
  }
}