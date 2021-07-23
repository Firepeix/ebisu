import 'package:flutter/material.dart';

class RadioInput extends StatelessWidget {
  final String? groupValue;
  final String label;
  final String value;
  final ValueChanged<String?> onChanged;

  RadioInput({required this.groupValue, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio (
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Text(label, style: TextStyle(fontSize: 16.0)),
          onTap: () => {
            onChanged(value)
          },
        )
      ],
    );
  }
}

class RadioGroup extends StatelessWidget  {
  final List<RadioInput> children;

  RadioGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children
        )
      ],
    );
  }
}

class SelectInput extends StatelessWidget  {
  final String? value;
  final ValueChanged<String?> onChanged;
  final TextStyle? style;
  final InputDecoration? decoration;
  final Map items;

  SelectInput({required this.items, required this.value, required this.onChanged, this.style, this.decoration});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              icon: Icon(Icons.arrow_downward_rounded),
              isDense: true,
              decoration: decoration,
              onChanged: onChanged,
              items: items.entries.map((e) => DropdownMenuItem(value: e.key.toString(), child: Text(e.value[0] + e.value.substring(1).toLowerCase()))).toList(),
            )
        )
      ],
    );
  }
}

