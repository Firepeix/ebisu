import 'package:ebisu/modules/card/infrastructure/transfer_objects/SaveCardModel.dart';
import 'package:flutter/material.dart';

class SaveCardNotification extends Notification {
  final SaveCardModel model;

  SaveCardNotification(this.model);
}