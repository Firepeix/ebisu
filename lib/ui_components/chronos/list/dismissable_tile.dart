import 'package:ebisu/ui_components/chronos/list/decorated_list_box.dart';
import 'package:flutter/material.dart';

class DismissibleTile extends StatelessWidget {
  final DecoratedListTileBox child;
  final DismissDirectionCallback? onDismissed;

  DismissibleTile({required this.child, this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(child.tile.id()),
      onDismissed: onDismissed,
      background: Container(color: Colors.red),
      child: child,
    );
  }
}