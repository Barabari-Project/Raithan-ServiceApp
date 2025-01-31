import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';

class PhonePage extends StatelessWidget {
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;

  PhonePage({
    super.key,
    required this.phoneController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.formFieldPadding, horizontal: AppDimensions.formFieldPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phone".tr,
            style: robotoBold.copyWith(
              color: black,
              fontSize: 26,
            ),
          ),
          Text(
            "You will get 6 digit OTP on your phone".tr,
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
                  label: 'Phone Number'.tr,
                  maxLength: 10,
                  isBuildCounterRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number'.tr;
                    }
                    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                      return 'Please enter a valid phone number'.tr;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
