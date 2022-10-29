import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
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

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _setEndpoint();
  }

  void _setEndpoint () async {
    final _endpoint = await widget._repository.getEndpointUrl();
    controller.text = _endpoint;
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Input(
        label: "Endpoint",
        innerController: controller,
        onFieldSubmitted: storeSheetId,
      ),
    );
  }
}