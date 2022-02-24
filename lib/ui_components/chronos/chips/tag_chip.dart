import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String name;
  final bool bold;
  final VoidCallback? onTap;

  const TagChip({Key? key, required this.name, this.bold = false, this.onTap}) : super(key: key);

  Widget _actionMode() => ActionChip(
    label: Text(name, style: TextStyle(fontWeight: bold ? FontWeight.w800 : null),),
    onPressed: () => onTap != null ? onTap!() : null,
  );

  Widget _normalMode() => Chip(
    label: Text(name, style: TextStyle(fontWeight: bold ? FontWeight.w800 : null),)
  );

  @override
  Widget build(BuildContext context) => onTap != null ? _actionMode() : _normalMode();
}
