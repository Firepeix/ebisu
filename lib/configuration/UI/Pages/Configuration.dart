import 'package:ebisu/configuration/UI/Components/CleanCredentials.dart';
import 'package:ebisu/configuration/UI/Components/SheetIdConfiguration.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/modules/configuration/components/background_configuration.dart';
import 'package:ebisu/modules/configuration/components/clear_cache_configuration.dart';
import 'package:ebisu/modules/configuration/components/endpoint_configuration.dart';
import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/modules/configuration/domain/services/background_service.dart';
import 'package:ebisu/modules/configuration/domain/services/cache_service.dart';
import 'package:ebisu/modules/user/entry/component/user_context.dart';
import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:flutter/material.dart';

class ConfigurationPage extends StatelessWidget {
  final _repository = getIt<ConfigRepositoryInterface>();
  final _backgroundService = getIt<BackgroundServiceInterface>();
  final _notificationService = getIt<NotificationService>();
  final _cacheService = getIt<CacheServiceInterface>();

  ConfigurationPage({super.key});

  Route getRoute(AppTheme userTheme, ThemeData theme) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => this,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: UserContext(id: userTheme, child: child, theme: theme,),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20),
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 0), child: SheetIdConfiguration(),),
          Padding(padding: EdgeInsets.only(top: 10), child: EndpointConfiguration(_repository, _notificationService),),
          Padding(padding: EdgeInsets.only(top: 10), child: BackgroundConfiguration(_backgroundService),),
          CleanCredentials(),
          ClearCacheConfiguration(_cacheService),
        ],
      ),
    );
  }
}
