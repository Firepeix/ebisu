import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/modules/configuration/domain/services/background_service.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:flutter/material.dart';

class BackgroundConfiguration extends StatelessWidget {
  final BackgroundServiceInterface _service;

  const BackgroundConfiguration(this._service, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Background(_service);
  }
}

class _Background extends StatefulWidget {
  final BackgroundServiceInterface _service;

  const _Background(this._service, {Key? key}) : super(key: key);

  @override
  State<_Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<_Background> {
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _setListen();
  }

  Future<void> _setListen() async {
    final should = await widget._service.isRunning();
    setState(() {
      isListening = should;
    });
  }

  void _updateListen(bool should) async {
    if (should) {
      await widget._service.install();
    }

    if (!should && await widget._service.isRunning()) {
      await widget._service.uninstall();
    }

    setState(() {
      isListening = should;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return ListTile(
      title: Row(children: [
        Label(
          text: "Rastrear Despesas",
          accent: null,
        ),
        Switch(
          value: isListening,
          onChanged: _updateListen,
          activeColor: color,
        )
      ]),
    );
  }
}
