import 'package:flutter/material.dart';

class BuildDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final Function(String?) onChanged;

  BuildDropdownField({
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }
}
