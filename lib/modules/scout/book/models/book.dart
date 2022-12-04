import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/material.dart';

enum BookAction {
  MARK_AS_READ,
  POSTPONE,
  ACTIVATE,
}

@immutable
class BookModel {
  final String id;
  final String name;
  final BookChapter chapter;
  final Moment? ignoredUntil;
  String get statusName => ignoredUntil != null ? "Desativado" : "Ativo";
  bool get isIgnored => ignoredUntil != null;

  BookModel({
    required this.id,
    required this.name,
    required this.chapter,
    this.ignoredUntil,
  });
}

@immutable
class BookChapter {
  final String value;

  BookChapter(this.value);

  BookChapter increment() {
    if (value.contains('.')) {
      return BookChapter((double.parse(value) + 0.1).toString());
    }

    return BookChapter((int.parse(value) + 1).toString());
  }
}
