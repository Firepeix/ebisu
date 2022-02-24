import 'package:flutter/material.dart';

abstract class EColor {
  static const int _main = 0xFFF44336;

  static const MaterialColor main = MaterialColor(
    _main,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(_main),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );

  static const int _accentValue = 0xFF2196F3;
  static const MaterialColor accent = MaterialColor(
    _accentValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(_accentValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  static const int _blackValue = 0xFF052007;
  static const MaterialColor black = MaterialColor(
    _blackValue,
    <int, Color>{
      50: Color(0xFF272C27),
      100: Color(0xFF141F15),
      200: Color(0xFF0A220C),
      300: Color(0xFF08220A),
      400: Color(0xFF052007),
      500: Color(0xFF052007),
      600: Color(0xFF001902),
      700: Color(0xFF001102),
      800: Color(0xFF000901),
      900: Color(0xFF000000),
    },
  );

  static const int _greyPrimaryValue = 0xFF8B8B8B;

  static const MaterialColor grey = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      350: Color(0xFFD6D6D6),
      400: Color(0xFFBDBDBD),
      500: Color(_greyPrimaryValue),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      850: Color(0xFF303030),
      900: Color(0xFF212121),
    },
  );

  static const int _success = 0xFF4CAF50;

  static const MaterialColor success = MaterialColor(
    _success,
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(_success),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );

  static const int _secondary = 0xFF9C27B0;

  static const MaterialColor secondary = MaterialColor(
    _secondary,
    <int, Color>{
      50: Color(0xFFF3E5F5),
      100: Color(0xFFE1BEE7),
      200: Color(0xFFCE93D8),
      300: Color(0xFFBA68C8),
      400: Color(0xFFAB47BC),
      500: Color(_secondary),
      600: Color(0xFF8E24AA),
      700: Color(0xFF7B1FA2),
      800: Color(0xFF6A1B9A),
      900: Color(0xFF4A148C),
    },
  );
}