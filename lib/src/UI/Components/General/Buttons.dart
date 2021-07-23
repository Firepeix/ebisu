import 'package:flutter/material.dart';

class FabHideOnKeyboard extends StatefulWidget {
  @override
  _FabHideOnKeyboardState createState() => new _FabHideOnKeyboardState();
}

class _FabHideOnKeyboardState extends State<FabHideOnKeyboard> {
  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom==0.0;
    return Scaffold(
      body:Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("TextField:"),
            TextField()
          ],
        ),
      ),
      floatingActionButton: showFab?Icon(Icons.add):null,
    );
  }
}