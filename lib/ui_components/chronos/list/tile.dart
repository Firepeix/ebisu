import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:ebisu/ui_components/chronos/labels/subtitle.dart';
import 'package:ebisu/ui_components/chronos/labels/text.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String title;
  final String? accent;
  final String? subtitle;
  final Widget? trailing;

  const Tile({Key? key, required this.title, this.accent, this.subtitle, this.trailing}) : super(key: key);

  Widget get _fullTitle {
    if (accent != null) {
      return Row(
        children: [NormalText(text: title), Label.main(text: accent!)],
      );
    }

    return Text(title);
  }

  @override
  Widget build(BuildContext context) => ListTile(
    title: _fullTitle,
    subtitle: subtitle != null ? Subtitle(text: subtitle!) : null,
    trailing: trailing,
    shape: Border(bottom: BorderSide(color: EColor.grey.shade300)),
  );
}