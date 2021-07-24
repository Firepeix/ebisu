import 'dart:io';

import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupApp extends StatefulWidget {
  final Function? onSetup;

  SetupApp(this.onSetup);

  @override
  _SetupAppState createState() => _SetupAppState();

  Widget build(_SetupAppState state) {
    return Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => state._openFileExplorer(),
                      child: const Text("Buscar Credenciais"),
                    ),
                    ElevatedButton(
                      onPressed: () => state._applyAuth(onSetup),
                      child: const Text("Aplicar Credenciais"),
                    ),
                  ],
                ),
                Builder(
                  builder: (BuildContext context) => state._loadingPath
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: const CircularProgressIndicator(),
                  )
                      : state._directoryPath != null
                      ? ListTile(
                    title: const Text('Directory path'),
                    subtitle: Text(state._directoryPath!),
                  )
                      : state._paths != null
                      ? Container(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    height:
                    MediaQuery.of(context).size.height * 0.50,
                    child: Scrollbar(
                        child: ListView.separated(
                          itemCount:
                          state._paths != null && state._paths!.isNotEmpty
                              ? state._paths!.length
                              : 1,
                          itemBuilder:
                              (BuildContext context, int index) {
                            final bool isMultiPath =
                                state._paths != null && state._paths!.isNotEmpty;
                            final String name = (isMultiPath
                                ? state._paths!
                                .map((e) => e.name)
                                .toList()[index]
                                : state._fileName ?? '...');
                            final path = state._paths!
                                .map((e) => e.path)
                                .toList()[index]
                                .toString();

                            return ListTile(
                              title: Text(
                                name,
                              ),
                              subtitle: Text(path),
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) =>
                          const Divider(),
                        )),
                  )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ));
  }
}

class _SetupAppState extends State<SetupApp> {
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths!.first.extension);
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  void _applyAuth(Function? onSetup) async {
    if (_paths != null) {
      final messenger = ScaffoldMessenger.of(context);

      try {
        File auth = File(_paths![0].path!);
        String credentials = await auth.readAsString();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(ExpenditureRepositoryInterface.CREDENTIALS_KEY, credentials);
        messenger.showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Sucesso - Credenciais Salvas'),
          ),
        );
        if(onSetup != null) {
          onSetup();
        }
      } catch (error) {
        messenger.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Falha - ' + error.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(this);
}