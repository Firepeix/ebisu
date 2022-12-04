import 'package:ebisu/ui_components/chronos/buttons/button.dart';
import 'package:ebisu/ui_components/chronos/labels/subtitle.dart';
import 'package:ebisu/ui_components/chronos/labels/title.dart';
import 'package:flutter/material.dart';

@immutable
class SelectOption<T> {
  final String text;
  final T value;
  final bool invert;
  final Icon? icon;

  SelectOption(this.text, this.value, {this.icon, this.invert = false});
}

class SelectDialog extends StatelessWidget {
  final String title;
  final List<SelectOption> options;
  final String? appendix;
  const SelectDialog(this.title, this.options, {this.appendix, Key? key}) : super(key: key);

  List<Widget> createOptions(BuildContext context) {
    final List<Widget> options = [];
    this.options.forEach((element) {
      options.add(Button(
          wide: true,
          icon: element.icon != null && !element.invert ? Icon(element.icon!.icon, color: Colors.white,) : element.icon,
          backgroundColor: element.icon?.color,
          foregroundColor: Colors.black,
          invert: element.invert,
          text: element.text,
          onPressed: () => Navigator.pop(context, element.value))
      );

      options.add(Padding(padding: EdgeInsets.symmetric(horizontal: 25)));
    });

    options.removeLast();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                ETitle(title),
                Padding(
                  padding: EdgeInsets.only(top: appendix != null ? 5 : 0),
                  child: Subtitle(text: appendix ?? ""),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: createOptions(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
