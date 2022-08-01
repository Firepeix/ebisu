import 'package:flutter/material.dart';

abstract class DecoratedTile implements Widget {
  String id();
}

class DecoratedListTileBox extends StatelessWidget {
  final DecoratedTile tile;
  final int index;
  const DecoratedListTileBox(this.tile, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: index == 0 ? Theme.of(context).dividerColor : Colors.transparent),
        ),
      ),
      child: tile,
    );
  }
}
