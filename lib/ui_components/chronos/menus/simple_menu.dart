import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:flutter/material.dart';

class SimpleMenu<T> extends StatefulWidget {
  final IconData icon;
  final List<MenuItem<T>> children;
  final PopupMenuItemSelected? onSelected;
  const SimpleMenu({Key? key,required this.icon,required this.children, this.onSelected}) : super(key: key);

  @override
  _SimpleMenuState createState() => _SimpleMenuState<T>(this.onSelected);
}

class _SimpleMenuState<T> extends State<SimpleMenu> {
  T? _selection;
  PopupMenuItemSelected<T>? onSelected;

  _SimpleMenuState(this.onSelected);

  @override
  Widget build(BuildContext context) => PopupMenuButton<T>(
    icon: Icon(widget.icon, color: EColor.black,),
    onSelected: (T result) {
      setState(() => _selection = result);
      onSelected?.call(_selection!);
    },
    itemBuilder: (BuildContext context) => widget.children.map((e) =>
        PopupMenuItem<T>(
          value: e.value,
          child: e.child,
        )
    ).toList(),
  );
}

class MenuItem<T> {
  final T value;
  final Widget child;

  MenuItem(this.value, this.child);
}