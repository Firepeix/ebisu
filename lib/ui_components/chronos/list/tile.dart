import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:ebisu/ui_components/chronos/labels/subtitle.dart';
import 'package:ebisu/ui_components/chronos/labels/text.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String? titleText;
  final String? subtitleText;
  final String? accent;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  Tile({Key? key, this.title, this.accent, this.subtitle, this.trailing, this.titleText, this.subtitleText, this.onTap}) : super(key: key) {
    assert(title != null || titleText != null);
  }

  Widget get _fullTitle {
    if (accent != null) {
      return Row(
        children: [Expanded(child: NormalText(text: titleText ?? "")), Label.main(text: accent!)],
      );
    }

    return Text(titleText ?? "");
  }

  @override
  Widget build(BuildContext context) => ListTile(
    title: title ?? _fullTitle,
    subtitle: subtitleText != null ? Subtitle(text: subtitleText!) : subtitle,
    trailing: trailing,
    shape: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
    onTap: this.onTap,
  );
}