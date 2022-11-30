import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:flutter/material.dart';

import '../../../shared/services/notification_service.dart';

enum _EndpointConfig { Local, Url }

typedef OnEndpointSet<T> = Future<void> Function(Application application, T value, _EndpointConfig config);
typedef OnEndpoinGet<T> = Future<T> Function(Application application, _EndpointConfig config);

class EndpointConfiguration extends StatelessWidget {
  final ConfigRepositoryInterface _repository;
  final NotificationService _notificationService;

  const EndpointConfiguration(this._repository, this._notificationService, {Key? key}) : super(key: key);

  Future<T> onEndpointGet<T>(Application application, _EndpointConfig config) async {
    if (config == _EndpointConfig.Local) {
      return await _repository.shouldUseLocalEndpoint(application) as T;
    }

    return await _repository.getLocalEndpoint(application) as T;
  }

  Future<void> onEndpointSet<T>(Application application, T value, _EndpointConfig config) async {
    if (config == _EndpointConfig.Local) {
      return await _repository.saveUseLocalEndpoint(application, value as bool);
    }
    _notificationService.displaySuccess(message: "Endpoint Salvo com Sucesso!");
    return await _repository.saveEndpointUrl(application, value as String);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_Endpoint(Application.Ebisu, onEndpointGet, onEndpointSet), _Endpoint(Application.Scout, onEndpointGet, onEndpointSet)],
    );
  }
}

class _Endpoint extends StatefulWidget {
  final Application _application;
  final OnEndpoinGet _onEndpoinGet;
  final OnEndpointSet _onEndpointSet;

  const _Endpoint(this._application, this._onEndpoinGet, this._onEndpointSet, {Key? key}) : super(key: key);

  @override
  State<_Endpoint> createState() => _EndpointState();
}

class _EndpointState extends State<_Endpoint> {
  late final TextEditingController controller;
  bool shouldUseLocalEndpoint = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _setEndpoint();
    _setUseLocalEndpoint();
  }

  void _setEndpoint() async {
    final _endpoint = await widget._onEndpoinGet(widget._application, _EndpointConfig.Url);
    controller.text = _endpoint;
  }

  Future<void> _setUseLocalEndpoint() async {
    final should = await widget._onEndpoinGet(widget._application, _EndpointConfig.Local);
    setState(() {
      shouldUseLocalEndpoint = should;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _updateEndpoint(String? endpoint) async {
    if (endpoint != null) {
      widget._onEndpointSet(widget._application, endpoint, _EndpointConfig.Url);
    }
  }

  void _updateShouldUseLocal(bool should) async {
    widget._onEndpointSet(widget._application, should, _EndpointConfig.Local);
    setState(() {
      shouldUseLocalEndpoint = should;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        ListTile(
          title: Input(
            label: "${widget._application.name} Endpoint",
            innerController: controller,
            onFieldSubmitted: _updateEndpoint,
          ),
        ),
        ListTile(
          title: Row(children: [
            Label(
              text: "Usar Local",
              accent: null,
            ),
            Switch(
              value: shouldUseLocalEndpoint,
              onChanged: _updateShouldUseLocal,
              activeColor: color,
            )
          ]),
        ),
      ],
    );
  }
}
