import 'package:flutter/material.dart';

class EbisuIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const EbisuIconButton({Key? key,required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black,)
  );
}
