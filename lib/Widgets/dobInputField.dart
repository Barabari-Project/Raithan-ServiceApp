import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';

class DOBInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const DOBInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  State<DOBInputField> createState() => _DOBInputFieldState();
}

class _DOBInputFieldState extends State<DOBInputField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        widget.controller.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true, // Prevent keyboard from appearing
      cursorColor: Colors.black,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Colors.black),
      decoration: InputDecoration(
        label: const Text("Date of Birth"),
        labelStyle:
            Theme.of(context).textTheme.titleSmall!.copyWith(color: grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderGrey,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderDarkGrey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderGrey,
        ),
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: grey,
        ),
      ),
      validator: widget.validator,
      onTap: () => _selectDate(context),
    );
  }
}
