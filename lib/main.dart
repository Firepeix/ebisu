import 'package:ebisu/configuration/UI/Pages/Configuration.dart';
import 'package:ebisu/domain/travel/models/travel_day_model.dart';
import 'package:ebisu/domain/travel/models/travel_expense_model.dart';
import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/modules/core/interactor.dart';
import 'package:ebisu/modules/notification/domain/notification_listener_service.dart';
import 'package:ebisu/shared/Infrastructure/Ebisu.dart';
import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'firebase_options.dart';
import 'main.config.dart';
import 'shared/Infrastructure/Providers/ServiceProvider.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void installDependencyInjection() {
  $initGetIt(getIt);
  ServiceContainer.register();
  register();
}

void register() {
  Hive.registerAdapter(TravelDayModelAdapter());
  Hive.registerAdapter(TravelExpenseModelAdapter());
}

void installDependencies() async {
  getIt<NotificationListenerService>().startListening();
}

void installExceptionHandler() {
  FlutterError.onError = (FlutterErrorDetails details) {
    getIt<ExceptionHandlerInterface>().expect(Result.err(UnknownError(Details(data: details))));
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    final service = getIt<ExceptionHandlerInterface>();
    service.expect(Result.err(service.parseError(error, alternativeStackTrace: stack)));
    return true;
  };
}

Future<void> installRelease() async {
  if (!kDebugMode) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await ConfigRepositoryInterface.install(FirebaseRemoteConfig.instance);
  }
}

void main() async {
  await Hive.initFlutter();
  await installRelease();
  installDependencyInjection();
  installDependencies();
  installExceptionHandler();
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
        '/': (context) => MyHomePage(title: 'Home'),
      },
      navigatorKey: _interactor.navigatorKey(),
      onGenerateRoute: (settings) {
        if (settings.name == "/configuration") {
          return ConfigurationPage(getIt<ConfigRepositoryInterface>(), getIt<NotificationService>())
              .getRoute();
        }

        if (_pageContainer.hasPage(settings.name ?? '')) {
          Map<String, dynamic> arguments =
              settings.arguments != null ? settings.arguments as Map<String, dynamic> : {};
          return _pageContainer.getPage(settings.name ?? '').getRoute(arguments);
        }

        if (settings.name != null && settings.name != "/") {
          final Map<String, dynamic> arguments =
              settings.arguments != null ? settings.arguments as Map<String, dynamic> : {};
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

void routeTo(BuildContext context, Widget view, {IntoViewAnimation? animation, OnReturnCallback? onReturn}) {
  getIt<NavigatorService>().routeTo(context, view, animation: animation, onReturn: onReturn);
}

void routeToPop(BuildContext context, Widget view, int times) {
  for (int i = 0; i < times; i++) {
    Navigator.pop(context);
  }

  routeTo(context, view);
}

void routeToBack(BuildContext context) {
  Navigator.pop(context);
}
