import 'package:ebisu/configuration/UI/Pages/Configuration.dart';
import 'package:ebisu/domain/travel/models/travel_day_model.dart';
import 'package:ebisu/domain/travel/models/travel_expense_model.dart';
import 'package:ebisu/modules/core/interactor.dart';
import 'package:ebisu/modules/scout/book/book.dart';
import 'package:ebisu/shared/Infrastructure/Ebisu.dart';
import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'main.config.dart';
import 'pages/travel/days/travel_expense_page.dart';
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
  register();
}

void register() {
  getIt<BookInterface>().register();
  Hive.registerAdapter(TravelDayModelAdapter());
  Hive.registerAdapter(TravelExpenseModelAdapter());
}

void main() async {
  await Hive.initFlutter();
  configureDependencies();
  runApp(MyApp(getIt<PageContainer>(), AppConfiguration()));
}

class MyApp extends StatelessWidget {
  final PageContainer _pageContainer;
  final AppConfiguration _configuration;
  final CoreInteractorInterface _interactor = getIt<CoreInteractorInterface>();

  MyApp(this._pageContainer, this._configuration);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebisu',
      theme: _configuration.getTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => _configuration.theme == AppTheme.tutu ? MyHomePage(title: 'Home') : TravelExpensePage(),
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

void routeTo(BuildContext context, Widget view, { IntoViewAnimation? animation, OnReturnCallback? onReturn }) {
  getIt<NavigatorService>().routeTo(context, view, animation: animation, onReturn: onReturn);
}

void routeToPop(BuildContext context, Widget view, int times) {
  for(int i = 0; i < times;i++) {
    Navigator.pop(context);
  }

  routeTo(context, view);
}

void routeToBack(BuildContext context) {
  Navigator.pop(context);
}
