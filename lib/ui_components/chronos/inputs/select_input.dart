import 'package:ebisu/ui_components/chronos/labels/subtitle.dart';
import 'package:flutter/material.dart';

abstract class CanBePutInSelectBox {
  String selectBoxLabel();
  Color? selectBoxColor();
}

abstract class HasSubtitlesInSelectBox {
  String selectBoxSubtitles();
}

class SelectInput<V extends CanBePutInSelectBox> extends StatelessWidget  {
  final String? label;
  final String? hint;
  final V? value;
  final ValueChanged<V?>? onChanged;
  final TextStyle? style;
  final List<V> items;
  final FormFieldValidator<V>? validator;
  final FormFieldSetter<V>? onSaved;

  SelectInput({
    this.label,
    this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.style,
    this.validator,
    this.onSaved
  });

  Widget box(V e) {
    final box = Text(e.selectBoxLabel(), style: TextStyle(color: e.selectBoxColor(), fontWeight: FontWeight.w500),);
    if(e is HasSubtitlesInSelectBox) {
      final text = (e as HasSubtitlesInSelectBox).selectBoxSubtitles();
      return Row(
        children: [box, Subtitle(text: " - $text")],
      );
    }

    return box;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: DropdownButtonFormField<V>(
              onSaved: onSaved,
              validator: validator,
              icon: Icon(Icons.arrow_downward_rounded),
              isDense: true,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: hint ?? '',
                  labelText: label ?? '',
                  errorStyle: const TextStyle(fontSize: 16),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 9)
              ),
              onChanged: onChanged,
              items: items.map((e) {
                return DropdownMenuItem(
                    value: e,
                    child: box(e)
                );
              }).toList(),
            )
        )
      ],
    );
  }
}
