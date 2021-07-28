import 'package:flutter/material.dart';

abstract class AbstractPage extends StatelessWidget  {
  final Function? onChangeTo;
  AbstractPage({this.onChangeTo});
}