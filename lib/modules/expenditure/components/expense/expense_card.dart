import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

class ExpenseListCard extends StatelessWidget {
  final ExpenseModel model;

  ExpenseListCard(this.model);

  Widget _getViewModel () {
    if (model.type.isDebit()) {
      return _DebitExpenditureViewModel(model);
    }

    if (model.isInstallmentBased()) {
      return _InstallmentPurchaseExpenditureViewModel(model);
    }

    return _CreditPurchaseExpenditureViewModel(model);
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade400, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: _getViewModel(),
      ),
    );
  }
}

class ExpenseCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(isLoading: true, child: Column(
        children: [
          Container(
            width: 351,
            height: 99,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              shape: BoxShape.rectangle,
            ),
          ),
        ],
      )),
    );
  }
}

abstract class _BaseExpenditureViewModel extends StatelessWidget {
  final ExpenseModel model;

  _BaseExpenditureViewModel(this.model);

  Widget getIcon() => Container(
        width: 60,
        height: 66,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.rectangle,
        ),
      );

  String _getSubtitle() => 'Placeholder';

  Widget? get topRightComponent => null;

  Widget? get bottomLeftComponent => null;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: getIcon()),
        Expanded(
            flex: 4,
            child: Container(
              height: 71,
              child: Row(
                children: [
                  Expanded(flex: 1,child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(top: 1), child: Text(model.name, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 22, height: 0.93, fontWeight: FontWeight.w500),),),
                                Padding(padding: EdgeInsets.only(top: 4), child: Text(_getSubtitle(), style: TextStyle(fontSize: 16),),),
                              ],
                            ),),
                            topRightComponent ?? Container()
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            bottomLeftComponent ?? Container(),
                            //Text(model.amount.real, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.red),)
                            Money(model.amount)
                          ],
                        )
                      ],
                    ),
                  )),
                ],
              ),
            )
        ),
      ],
    );
  }
}

class _DebitExpenditureViewModel extends _BaseExpenditureViewModel {
  _DebitExpenditureViewModel(ExpenseModel model) : super(model);

  @override
  String _getSubtitle() => 'Débito';

  Widget getIcon() => Container(
    width: 71,
    height: 71,
    child: Icon(Icons.money, size: 71, color: Colors.white,),
      decoration: const BoxDecoration(
        color: Color(0xFFEF5350),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      )
  );
}

class _CreditPurchaseExpenditureViewModel extends _BaseExpenditureViewModel {
  _CreditPurchaseExpenditureViewModel(ExpenseModel model) : super(model);

  @override
  String _getSubtitle() => 'Credito';

  Widget getIcon() => Container(
      width: 71,
      height: 71,
      child: Icon(Icons.credit_card, size: 71, color: Colors.white,),
      decoration: BoxDecoration(
        color: Color(0xFFEF5350),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        shape: BoxShape.rectangle,
      )
  );

  @override
  Widget? get bottomLeftComponent => Text(model.card!.name, style: TextStyle(fontSize: 16, color: model.card!.color, height: 1, fontWeight: FontWeight.w500));
}

class _InstallmentPurchaseExpenditureViewModel extends _CreditPurchaseExpenditureViewModel {
  _InstallmentPurchaseExpenditureViewModel(ExpenseModel model) : super(model);

  Widget getIcon() => Container(
      width: 71,
      height: 71,
      child: Icon(Icons.date_range, size: 71, color: Colors.white,),
      decoration: BoxDecoration(
        color: Color(0xFFEF5350),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        shape: BoxShape.rectangle,
      )
  );

  @override
  Widget? get topRightComponent => Text(model.installments!.summary, style: TextStyle(fontSize: 16, height: 1, fontWeight: FontWeight.w500));
}

