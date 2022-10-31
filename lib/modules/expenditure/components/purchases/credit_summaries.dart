import 'package:ebisu/main.dart';
import 'package:ebisu/modules/card/pages/update_card_page.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shared/UI/Components/Grids.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/ui_components/chronos/buttons/transparent_button.dart';
import 'package:ebisu/ui_components/chronos/cards/general_card.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

class CreditSummaries extends StatelessWidget {
  final List<CreditExpensePurchaseSummaryModel> summaries;

  const CreditSummaries({required this.summaries});

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 14),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
              childAspectRatio: 1 / 1.19,
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 2,
              itemCount: summaries.length
            ),
            itemCount: summaries.length,
            itemBuilder: (BuildContext context, int index) {
                return _CreditSummary(summary: summaries[index],);
            },
        ),
  );
}

class _CreditSummary extends StatelessWidget {
  final CreditExpensePurchaseSummaryModel summary;

  const _CreditSummary({required this.summary});

  @override
  Widget build(BuildContext context) {
    return GeneralCard(
      elevation: 4,
      hasOwnPadding: true,
      child: TransparentButton(
        () => routeTo(context, UpdateCardPage(summary.card.id, summary.card.name), animation: IntoViewAnimation.pop),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(summary.card.name,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:  summary.card.color
                    ),
                  ),
                  Padding(child: Text('Planejado', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),), padding: EdgeInsets.only(top: 4)),
                  Money(summary.planned, color: Colors.black, size: 22),
                  Padding(child: Text('Parcelado', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),), padding: EdgeInsets.only(top: 4)),
                  Money(summary.previousInstallmentSpent, color: Colors.black, size: 22),
                  Padding(child: Text('Gasto atual', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),), padding: EdgeInsets.only(top: 4),),
                  Money(summary.spent, color: Colors.black, size: 22,),
                ],
              ),
            ),
            EbisuDivider(),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Money(summary.difference, size: 22, valueBasedColor: true,)
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}


class CreditSummariesSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Shimmer(
        child: ShimmerLoading(isLoading: true, child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 14),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 2,
                childAspectRatio: 1 / 0.91,
                itemCount: 2
            ),
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) => Container(
              height: 177.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                shape: BoxShape.rectangle,
              ),
            ),
          ),
        )
        ),
      ); /* @override
  Widget build(BuildContext context) =>
      Shimmer(
        child: ShimmerLoading(isLoading: true, child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 20), child:
                Row(
                  children: List.generate(2, (index) => Padding(padding: EdgeInsets.only(right: 4, left: 4), child:
                  Container(
                    width: 122,
                    height: 177.0,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      shape: BoxShape.rectangle,
                    ),
                  ),)),
                )
            )
          ],
        )),
      );*/
}
