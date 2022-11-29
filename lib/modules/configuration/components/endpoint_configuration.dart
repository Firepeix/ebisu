import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:flutter/material.dart';

import '../../../shared/services/notification_service.dart';

class EndpointConfiguration extends StatefulWidget {
  final ConfigRepositoryInterface _repository;
  final NotificationService _notificationService;

  const EndpointConfiguration(this._repository, this._notificationService, {Key? key}) : super(key: key);

  @override
  State<EndpointConfiguration> createState() => _EndpointConfigurationState();
}

class _EndpointConfigurationState extends State<EndpointConfiguration> {
  late final TextEditingController controller;
  bool shouldUseLocalEndpoint = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _setEndpoint();
    _setUseLocalEndpoint();
  }

  void _setEndpoint () async {
    final _endpoint = await widget._repository.getLocalEndpoint();
    controller.text = _endpoint;
  }

  Future<void> _setUseLocalEndpoint() async {
    final should = await widget._repository.shouldUseLocalEndpoint();
    setState(() {
      shouldUseLocalEndpoint = should;
    });
  }


  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void storeSheetId(String? endpoint) async {
    if (endpoint != null) {
      widget._repository.saveEndpointUrl(endpoint);
      widget._notificationService.displaySuccess(message: "Salvo com sucesso!");
    }
  }

  void localUsageOfEndpoint(bool should) async {
    widget._repository.saveUseLocalEndpoint(should);
    setState(() {
      shouldUseLocalEndpoint = should;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        ListTile( title: Input(label: "Endpoint", innerController: controller, onFieldSubmitted: storeSheetId, ),),
        ListTile(
          title: Row(
              children: [
                Label(text: "Usar Local", accent: null,),
                Switch(
                    value: shouldUseLocalEndpoint,
                    onChanged: localUsageOfEndpoint,
                  activeColor: color,
                )
              ]
          ),
        ),
      ],
    );
  }
}