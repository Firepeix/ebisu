import 'package:ebisu/main.dart';
import 'package:ebisu/modules/card/pages/update_card_page.dart';
import 'package:ebisu/modules/common/core/domain/money.dart' as V;
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/modules/purchases/credit/entry/components/strings.dart';
import 'package:ebisu/modules/user/entry/component/user_context.dart';
import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shared/UI/Components/Grids.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/ui_components/chronos/buttons/billboard_button.dart';
import 'package:ebisu/ui_components/chronos/buttons/transparent_button.dart';
import 'package:ebisu/ui_components/chronos/cards/general_card.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/material.dart';

class CreditSummaries extends StatelessWidget {
  static const double KNOWN_ITEM_WIDTH = 194.7;
  static const double KNOWN_DEVICE_WIDTH = 411.42857142857144;

  final List<CreditExpensePurchaseSummaryModel> summaries;

  const CreditSummaries({required this.summaries});

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    final itemHeight = 235;
    final itemWidth = (windowWidth * KNOWN_ITEM_WIDTH) / KNOWN_DEVICE_WIDTH;
    final ratio = itemWidth / itemHeight;

    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 14),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
            childAspectRatio: ratio,
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 2,
            itemCount: summaries.length),
        itemCount: summaries.length,
        itemBuilder: (BuildContext context, int index) {
          return _CreditSummary(
            summary: summaries[index],
          );
        },
      ),
    );
  }
}

class _CreditSummary extends StatelessWidget {
  final CreditExpensePurchaseSummaryModel summary;

  const _CreditSummary({required this.summary});

  Widget _bank(UserContext context) {
    final closeDate = Moment(DateTime.now().copyWith(day: summary.card.closeDate?.day ?? 1));

    return Column(
      children: [
        Text(
          summary.card.name,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: summary.card.color),
        ),
        context.show(wewe: Padding(padding: EdgeInsets.only(bottom: 0), child: Text("${closeDate.addMonths(1)}",)))
      ],
    );
  }


  Widget _planned(UserContext context) {
    return _item(title: "Planejado", value: summary.planned);
  }

  Widget _installments(UserContext context) {
    final title = context.localize(CreditSummaryStrings.installment);

    return context.toggle(
        tutu: _item(title: title, value: summary.previousInstallmentSpent),
        wewe: _item(title: title, value: summary.previousInstallmentSpent, onPressed: () {})
    );
  }

  Widget _spent(UserContext context) {
    final title = context.localize(CreditSummaryStrings.spent);

    return context.toggle(
        tutu: _item(title: title, value: summary.spent),
        wewe: _item(title: title, value: summary.spent, onPressed: () {})
    );
  }

  Widget _available(UserContext context) {
    return context.toggle(
        wewe: _item(title: 'Limite Disponivel', value: summary.difference, onPressed: () {}),
        tutu: Padding(
          padding: EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MoneyLabel(
                summary.difference,
                size: 22,
                valueBasedColor: true,
              )
            ],
          ),
        ),
    );
  }

  Widget _item({required String title, required V.Money value, VoidCallback? onPressed}) {
    if(onPressed != null) {
      return Padding(
          padding: EdgeInsets.only(top: 5),
        child: BillboardButton(
          leading: title,
          main: value.toReal(),
          onPressed: onPressed,
        ),
      );
    }

    return Column(
      children: [
        Padding(
          child: Text(title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400
            ),
          ),
          padding: EdgeInsets.only(top: 4),
        ),
        MoneyLabel(
          value,
          color: Colors.black,
          size: 22,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userContext = UserContext.of(context);

    return GeneralCard(
      borderColor: userContext.theme.primaryColorLight,
      hasOwnPadding: true,
      child: TransparentButton(
          onPressed: () => routeTo(context, UpdateCardPage(summary.card.id, summary.card.name),  animation: IntoViewAnimation.pop),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: userContext.toggle(tutu: 10, wewe: 4), left: 10, right: 10, bottom: userContext.toggle(tutu: 12, wewe: 4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _bank(userContext),
                    userContext.toggle(tutu: _planned(userContext), wewe: _spent(userContext)),
                    _installments(userContext),
                    userContext.show(tutu: _spent(userContext)),
                  ],
                ),
              ),
              userContext.show(tutu: EbisuDivider()),
              userContext.toggle(
                  tutu: _available(userContext),
                  wewe: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    child: _available(userContext),
                  )
              )
            ],
          )),
    );
  }
}

class CreditSummariesSkeleton extends StatelessWidget {
  final int quantity;
  const CreditSummariesSkeleton(this.quantity);

  @override
  Widget build(BuildContext context) => Shimmer(
        child: ShimmerLoading(
            isLoading: true,
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 14),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                    childAspectRatio: 1 / 1.25,
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 2,
                    itemCount: quantity),
                itemCount: quantity,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  );
                },
              ),
            )),
      );
}
