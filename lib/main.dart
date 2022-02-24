import 'package:ebisu/configuration/UI/Pages/Configuration.dart';
import 'package:ebisu/modules/core/interactor.dart';
import 'package:ebisu/shared/Infrastructure/Ebisu.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'main.config.dart';
import 'shared/Infrastructure/Providers/ServiceProvider.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() {
  $initGetIt(getIt);
  ServiceContainer.register();
}

void main() {
  Hive.initFlutter().then((value) {
    configureDependencies();
    runApp(MyApp(getIt<PageContainer>()));
  });}

class MyApp extends StatelessWidget {
  final PageContainer _pageContainer;
  final CoreInteractorInterface _interactor = getIt<CoreInteractorInterface>();

  MyApp(this._pageContainer);

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
      navigatorKey: _interactor.navigatorKey(),
      onGenerateRoute: (settings) {
        if (settings.name == "/configuration") {
          return ConfigurationPage().getRoute();
        }

        if (_pageContainer.hasPage(settings.name ?? '')) {
          Map<String, dynamic> arguments = settings.arguments != null ? settings.arguments as Map<String, dynamic> : {};
          return _pageContainer.getPage(settings.name ?? '').getRoute(arguments);
        }

        if (settings.name != null && settings.name != "/") {
          final Map<String, dynamic> arguments = settings.arguments != null ? settings.arguments as Map<String, dynamic> : {};
          if (arguments.containsKey('navigator')) {
            final navigator = arguments['navigator'] as NavigatorInterface;
            arguments.remove('navigator');
            return navigator.route(settings.name!, arguments);
          }
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
