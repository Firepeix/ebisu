import 'package:ebisu/configuration/UI/Pages/Configuration.dart';
import 'package:ebisu/shared/Infrastructure/Ebisu.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'main.config.dart';
final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => $initGetIt(getIt);

void main() {
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebisu',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Home'),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/configuration") {
          return ConfigurationPage.getRoute();
        }
        // Unknown route
        return MaterialPageRoute(builder: (_) => MyHomePage(title: 'Home'));
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return EbisuMainView();
  }
}
