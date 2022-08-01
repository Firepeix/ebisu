import 'package:flutter/material.dart';

abstract class AbstractButton extends Widget {
  final VoidCallback? onPressed;

  const AbstractButton({Key? key, required this.onPressed}) : super(key: key);
}


abstract class StatelessAbstractButton extends StatelessWidget implements AbstractButton {
  final VoidCallback? onPressed;

  const StatelessAbstractButton({Key? key, required this.onPressed}) : super(key: key);
}

abstract class StatefulAbstractButton extends StatefulWidget implements AbstractButton  {
  @override
  VoidCallback? get onPressed => () {

  };

  const StatefulAbstractButton({Key? key}) : super(key: key);
}