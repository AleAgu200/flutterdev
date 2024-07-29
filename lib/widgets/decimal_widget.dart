import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DecimalExample extends StatefulWidget {
  @override
  _DecimalExampleState createState() => _DecimalExampleState();
}

class _DecimalExampleState extends State<DecimalExample> {
  double _currentValue = 3.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DecimalNumberPicker(
          value: _currentValue,
          minValue: 0.0,
          maxValue: 100.0,
          decimalPlaces: 1,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
        Text('Current value: $_currentValue'),
      ],
    );
  }
}

class DecimalNumberPicker extends StatefulWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final int decimalPlaces;
  final ValueChanged<double> onChanged;

  DecimalNumberPicker({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.decimalPlaces,
    required this.onChanged,
  });

  @override
  _DecimalNumberPickerState createState() => _DecimalNumberPickerState();
}

class _DecimalNumberPickerState extends State<DecimalNumberPicker> {
  late int _currentIntValue;
  late int _currentDecimalValue;

  @override
  void initState() {
    super.initState();
    _currentIntValue = widget.value.toInt();
    _currentDecimalValue = ((widget.value - _currentIntValue) * 10).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NumberPicker(
          value: _currentIntValue,
          minValue: widget.minValue.toInt(),
          maxValue: widget.maxValue.toInt(),
          onChanged: (value) {
            setState(() {
              _currentIntValue = value;
              _updateValue();
            });
          },
        ),
        Text('.'),
        NumberPicker(
          value: _currentDecimalValue,
          minValue: 0,
          maxValue: (10 * widget.decimalPlaces - 1).toInt(),
          onChanged: (value) {
            setState(() {
              _currentDecimalValue = value;
              _updateValue();
            });
          },
        ),
      ],
    );
  }

  void _updateValue() {
    double newValue = _currentIntValue + (_currentDecimalValue / 10);
    widget.onChanged(newValue);
  }
}
