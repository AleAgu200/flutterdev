import 'package:flutter/material.dart';

class BuildDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(DateTime)? onDateSelected;

  BuildDateField({
    required this.label,
    required this.controller,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            if (onDateSelected != null) {
              onDateSelected!(pickedDate);
            }
          }
        },
        readOnly: true,
      ),
    );
  }
}
