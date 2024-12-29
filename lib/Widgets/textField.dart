import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String label;
  final String? Function(String?)? validator;

  const CustomTextfield({
    super.key,
    required this.controller,
    this.type = TextInputType.text,
    required this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      cursorColor: black,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: black),
      decoration: InputDecoration(
        label: Text(label),
        labelStyle:
            Theme.of(context).textTheme.titleSmall!.copyWith(color: grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grey),
        ),
      ),
      validator: validator,
      maxLength: type == TextInputType.phone
          ? 10
          : null, // Set maxLength to 10 for phone input
    );
  }
}
