import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';

class DOBInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  void Function(String)? onFieldSubmitted;

  DOBInputField({
    super.key,
    required this.controller,
    this.validator,
    this.focusNode,
    this.onFieldSubmitted
  });

  @override
  State<DOBInputField> createState() => _DOBInputFieldState();
}

class _DOBInputFieldState extends State<DOBInputField> {
  Future<void> _selectYear(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    DateTime selectedDate = currentDate;

    await showDialog(
      context: context,
      barrierDismissible: true, // Allows tapping outside to close
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white, // Ensure clean background
        elevation: 0,
        child: SizedBox(
          height: 300,
          child: Material(
            color: Colors.transparent, // Remove shadow overlay
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: currentDate,
              initialDate: currentDate,
              selectedDate: selectedDate,
              onChanged: (DateTime date) {
                setState(() {
                  widget.controller.text = "${date.year}";
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true, // Prevent keyboard from appearing
      cursorColor: Colors.black,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Colors.black),
      decoration: InputDecoration(
        label: Text("Year of Birth".tr),
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
      onTap: () => _selectYear(context),
    );
  }
}
