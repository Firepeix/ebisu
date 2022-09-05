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
  String ebisuEndpoint;

  AppConfiguration._init({
    required this.theme,
    required this.user,
    required this.features,
    required this.travelSheetId,
    required this.ebisuEndpoint,
  });

  factory AppConfiguration() {
    return _inner;
  }

  factory AppConfiguration._internal() {
    final features = (const String.fromEnvironment("FEATURES", defaultValue: "")).split(",").map((e) => _Feature(e)).toList();
    final userId = const String.fromEnvironment("USER", defaultValue: "tutu");
    final ebisuEndpoint = const String.fromEnvironment("EBISU_ENDPOINT", defaultValue: "http://localhost");

    return AppConfiguration._init(
        user: _User.fromId(userId),
        theme: const String.fromEnvironment("THEME", defaultValue: "wewe") == AppTheme.tutu.name ? AppTheme.tutu : AppTheme.wewe,
        travelSheetId: const String.fromEnvironment("TRAVEL_SHEET_ID", defaultValue: ""),
        features: features,
        ebisuEndpoint: ebisuEndpoint
    );
  }
  
  ThemeData getTheme() {
    return theme == AppTheme.tutu ? _tutuTheme() : _weweTheme();
  }

  ThemeData _tutuTheme() {
    return ThemeData(
      primaryColor: Colors.red,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, primary: Colors.red, secondary: Colors.redAccent),
    );
  }
  
  ThemeData _weweTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, primary: Colors.lightBlue, secondary: Colors.orangeAccent),
    );
  }
}