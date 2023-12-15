import 'package:ebisu/modules/user/entry/component/user_context.dart';
import 'package:flutter/material.dart';

enum CardMode {
  ACTIVE,
  NORMAL
}

class GeneralCard extends StatelessWidget {
  final Widget child;
  final double? elevation;
  final bool hasOwnPadding;
  static const double padding = 8;
  final VoidCallback? onPressed;
  final CardMode mode;
  final Color? borderColor;

  const GeneralCard({super.key, required this.child, this.elevation, this.hasOwnPadding = false, this.onPressed, this.mode = CardMode.NORMAL, this.borderColor});


  Widget _content() {
    if (onPressed != null && mode != CardMode.ACTIVE) {
      return Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(hasOwnPadding ? 0 : padding),
            child: child,
          ),
        ),
        color: Colors.transparent,
      );
    }

    return Padding(
      padding: EdgeInsets.all(hasOwnPadding ? 0 : padding),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userContext = UserContext.of(context);
    return Card(
      color: mode == CardMode.ACTIVE ? Colors.pink.shade50 : null,
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: mode == CardMode.ACTIVE ? userContext.theme.primaryColor : (borderColor ?? Colors.grey.shade400), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(5)
          )
      ),
      child: _content(),
    );
  }
}
