import 'package:ebisu/card/Domain/Card.dart' as CardModel;
import 'package:ebisu/expenditure/Domain/ExpenditureSummary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Shimmer.dart';

class CreditSummaries extends StatelessWidget {
  final List<ExpenditureSummary> summaries;

  const CreditSummaries({required this.summaries});

  @override
  Widget build(BuildContext context) =>
      Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Row(
        children: summaries.map((summary) => _CreditSummary(summary: summary))
            .toList(),
      ),);
}

class _CreditSummary extends StatelessWidget {
  final ExpenditureSummary summary;

  const _CreditSummary({required this.summary});

  @override
  Widget build(BuildContext context) =>
      Expanded(child: Card(
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(summary.title!, style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CardModel
                          .CardType(summary.title!)
                          .color),),
                  Padding(padding: EdgeInsets.only(top: 4),
                    child: Text('Planejado', style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),),),
                  Text(summary.budget.real, style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),),
                  Padding(padding: EdgeInsets.only(top: 4),
                    child: Text('Gasto', style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),),),
                  Text(summary.spent.real, style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            Container(
              height: 3,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.rectangle,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(summary.result.real, style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: summary.result.value > 0
                          ? Colors.green.shade800
                          : Colors.red.shade800),),
                ],
              ),
            )
          ],
        ),
      ));
}

class CreditSummariesSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Shimmer(
        child: ShimmerLoading(isLoading: true, child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 20), child:
                Row(
                  children: List.generate(3, (index) => Padding(padding: EdgeInsets.only(right: 4, left: 4), child:
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
      );
}
