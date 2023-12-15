import 'package:ebisu/shared/utils/matcher.dart';
import 'package:flutter/material.dart';

enum AppTheme {
  tutu,
  wewe
}

class _User {
  final String name;
  final String email;

  _User(this.name, this.email);
  
  factory _User.fromId(String id) {
    final defaultUser = _User("Arthur Fernandes", "arthurhmf@gmail.com");
    return Matcher.matchWhen(id, {
      "wewe": _User("Wendy Artiaga", "wendy.artiaga@gmail.com"),
      "tutu": defaultUser
    }, base: defaultUser);
  }
}

class _Feature {
  final String id;

  _Feature(this.id);
}

class AppConfiguration {
  static final AppConfiguration _inner = AppConfiguration._internal();
  AppTheme theme;
  _User user;
  List<_Feature> features;
  String travelSheetId;

  AppConfiguration._init({
    required this.theme,
    required this.user,
    required this.features,
    required this.travelSheetId,
  });

  factory AppConfiguration() {
    return _inner;
  }

  factory AppConfiguration._internal() {
    final features = (const String.fromEnvironment("FEATURES", defaultValue: "expenses,shopping,books,travel")).split(",").map((e) => _Feature(e)).toList();
    return AppConfiguration._init(
      user: _User.fromId(const String.fromEnvironment("USER", defaultValue: "tutu")),
      theme: const String.fromEnvironment("THEME", defaultValue: "tutu") == AppTheme.tutu.name ? AppTheme.tutu : AppTheme.wewe,
      travelSheetId: const String.fromEnvironment("TRAVEL_SHEET_ID", defaultValue: ""),
      features: features,
    );
  }
  
  ThemeData getTheme() {
    return theme == AppTheme.tutu ? tutuTheme() : weweTheme();
  }

  static ThemeData tutuTheme() {
    return ThemeData(
      primaryColor: Colors.red,
      primaryColorLight: Colors.red.shade300,
      colorScheme: ColorScheme.fromSeed(
          primaryContainer: Colors.red[700],
          seedColor: Colors.red,
          primary: Colors.red,
          secondary: Colors.redAccent,
      ),
    );
  }
  
  static ThemeData weweTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
          primaryContainer: Colors.blue[700],
          seedColor: Colors.lightBlue,
          primary: Colors.lightBlue,
          secondary: Colors.orangeAccent
      ),
    );
  }
}