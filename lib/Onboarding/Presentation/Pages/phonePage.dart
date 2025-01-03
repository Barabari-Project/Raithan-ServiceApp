import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';

class PhonePage extends StatelessWidget {
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;

  const PhonePage({
    super.key,
    required this.phoneController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone",
          style: robotoBold.copyWith(
            color: black,
            fontSize: 26,
          ),
        ),
        Text(
          "You will get 6 digit OTP on your phone",
          style: robotoBold.copyWith(
            color: Colors.black45,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextfield(
                controller: phoneController,
                type: TextInputType.phone,
                label: 'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
