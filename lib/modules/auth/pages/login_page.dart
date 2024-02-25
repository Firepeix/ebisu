import 'package:ebisu/main.dart';
import 'package:ebisu/modules/auth/domain/services/auth_service.dart';
import 'package:ebisu/ui_components/chronos/buttons/button.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final AuthServiceInterface service;
  const LoginPage(this.service, {Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;

  GlobalKey<FormState>? _form;

  @override
  void initState() {
    super.initState();
    _form = GlobalKey();
  }

  @override
  void dispose() {
    super.dispose();
    _form = null;
  }

  Future<void> _login() async {
    final result = await widget.service.login(email!, password!);
    result.let(ok: (_) => routeToBack(context));
  }

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Login",
      child: Form(
        key: _form,
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 30)),
              Input(
                label: "Email",
                validator: (value) => value != "" ? null : "Email é obrigatório",
                onSaved: (value) => email = value,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Input(
                  label: "Senha",
                  validator: (value) => value != "" ? null : "Senha é obrigatória",
                  onSaved: (value) => password = value,
                  obscureText: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Button(
                    text: "Login",
                    onPressed: () {
                      _form?.currentState?.validate();
                      _form?.currentState?.save();
                      _login();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
