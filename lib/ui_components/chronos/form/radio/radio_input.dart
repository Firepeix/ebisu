import 'package:flutter/material.dart';

class RadioInput<T> extends StatelessWidget {
  final T? groupValue;
  final String label;
  final T value;
  final ValueChanged<T?>? onChanged;

  RadioInput({required this.groupValue, required this.label, required this.value, this.onChanged});

  void _selectValue(T? value) {
    onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          child: Radio<T>(
            activeColor: Theme.of(context).colorScheme.primary,
            value: value,
            groupValue: groupValue,
            onChanged: _selectValue,
          ),
        ),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Text(label, style: TextStyle(fontSize: 16.0)),
          onTap: () => _selectValue(value),
        )
      ],
    );
  }
}

class RadioGroup<T> extends FormField  {
  final List<RadioInput> children;

  RadioGroup({
    required this.children,
    Function? validator,
    FormFieldSetter<int>? onSaved
  }) : super(
      builder: (FormFieldState state) => build(children, state),
      validator: (value) {
        if (validator == null) {
          return null;
        }
        return validator();
      },
  );

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