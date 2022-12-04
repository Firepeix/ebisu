import 'package:ebisu/main.dart';
import 'package:ebisu/modules/core/components/drawer.dart';
import 'package:ebisu/modules/core/interactor.dart';
import 'package:ebisu/ui_components/chronos/bodies/body.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:flutter/material.dart';

class ViewBody extends StatelessWidget {
  final String title;
  final Widget? child;
  final CFloatActionButton? fab;
  final Color? bgColor;
  final Body? body;
  final bool hasAccessToConfig;

  const ViewBody({
    this.bgColor,
    required this.title,
    this.child,
    this.fab,
    this.body,
    this.hasAccessToConfig = true,
    Key? key,
  })  : assert(child != null || body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: hasAccessToConfig ?  [
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 26.0,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/configuration');
            },
          )
        ]: null,
      ),
      drawer: EbisuDrawer(getIt<CoreInteractorInterface>()),
      floatingActionButton: fab?.button,
      floatingActionButtonLocation: fab?.location,
      body: body ?? Body(child: child!),
      backgroundColor: bgColor,
    );
  }
}
