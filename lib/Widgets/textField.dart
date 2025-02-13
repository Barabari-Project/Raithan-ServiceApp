import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String label;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool? isBuildCounterRequired;
  final bool? readOnly;
  final Widget? suffixIcon;
  void Function(String)? onChanged;
  void Function()? onTap;
  void Function(String)? onFieldSubmitted;

  CustomTextfield({
    super.key,
    required this.controller,
    this.type = TextInputType.text,
    required this.label,
    this.validator,
    this.focusNode,
    this.maxLength,
    this.isBuildCounterRequired,
    this.onChanged,
    this.readOnly,
    this.suffixIcon,
    this.onTap,
    this.onFieldSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      readOnly: readOnly ?? false,
      cursorColor: black,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: black),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
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
      maxLength: maxLength, //
      buildCounter: (isBuildCounterRequired  != null && isBuildCounterRequired == true)? null : (context, {required currentLength, maxLength, required isFocused}) => null,// Set maxLength to 10 for phone input
    );
  }
}
