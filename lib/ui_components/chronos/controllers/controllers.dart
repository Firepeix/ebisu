import 'package:flutter/material.dart';

abstract class Controller {

  TextEditingController getController();
  String text();

  void dispose();
}