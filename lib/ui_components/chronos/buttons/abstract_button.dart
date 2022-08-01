import 'package:flutter/material.dart';

abstract class AbstractButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AbstractButton({Key? key, required this.onPressed}) : super(key: key);
}