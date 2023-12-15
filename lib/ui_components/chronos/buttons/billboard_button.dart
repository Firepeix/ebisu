import 'package:ebisu/modules/user/entry/component/user_context.dart';
import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:flutter/material.dart';

class BillboardButton extends StatelessWidget {

  final String leading;
  final VoidCallback onPressed;
  final String main;

  const BillboardButton({super.key, required this.leading, required this.onPressed, required this.main});

  @override
  Widget build(BuildContext context) {
    final userContext = UserContext.of(context);


    return Material(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: userContext.theme.primaryColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        splashColor: userContext.theme.primaryColorLight,
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: userContext.theme.primaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(leading, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ),
            SummaryDivider(width: 1),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: Text(main, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
      color: Colors.transparent,
    );
  }
}
