import 'package:bluecircle/features/profile_setup/profile_setup_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DOBPickerField extends StatelessWidget {
  final ProfileSetupController controller;
  final String labelText;

  const DOBPickerField({
    Key? key,
    required this.controller,
    this.labelText = "Date of Birth",
  }) : super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime initialDate = DateTime.tryParse(controller.dobController.text) ?? today.subtract(Duration(days: 365 * 5));
    DateTime firstDate = DateTime(today.year - 100); 
    DateTime lastDate = today;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      controller.dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  TextField(
          controller: controller.dobController,
          readOnly: true,
          onTap: () => _pickDate(context),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: "yyyy-mm-dd",
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
  }
}
