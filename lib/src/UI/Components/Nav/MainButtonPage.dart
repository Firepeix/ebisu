import 'package:flutter/material.dart';

abstract class MainButtonPage {
  FloatingActionButton getMainButton (BuildContext context, VoidCallback? onPressed);
}