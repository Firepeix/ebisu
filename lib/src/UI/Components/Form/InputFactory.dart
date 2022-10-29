import 'package:flutter/material.dart';

class RadioInput extends StatelessWidget {
  final int? groupValue;
  final String label;
  final int value;
  final ValueChanged<int?> onChanged;

  RadioInput({required this.groupValue, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          child: Radio (
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
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

class RadioGroup extends FormField  {
  final List<RadioInput> children;

  RadioGroup({required this.children, FormFieldValidator? validator, FormFieldSetter<int>? onSaved}) :
        super(builder: (FormFieldState state) => build(children, state), validator: validator, onSaved: (dynamic value) => onSaved!(value));

  static Widget build(List<RadioInput> children, FormFieldState state) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children
        ),
        AnimatedOpacity(
            opacity: state.hasError ? 1 : 0,
            duration:  Duration(milliseconds: 400),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: state.hasError ? 20 : 0,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(state.errorText ?? '', style: TextStyle(fontSize: 16, color: Color(0xFFD32332))),
              ),
            )
        )
      ],
    );
  }
}

