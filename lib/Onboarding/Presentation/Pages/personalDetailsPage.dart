import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Widgets/dobInputField.dart';
import 'package:raithan_serviceapp/Widgets/imageInputFeild.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';

class PersonalDetailsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController; // If DOB needs text input
  final TextEditingController
      imageController; // If image URI or path is stored as string

  const PersonalDetailsPage({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.dobController,
    required this.imageController,
  });

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Details",
              style: robotoBold.copyWith(
                color: black,
                fontSize: 20,
              ),
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.firstNameController,
              type: TextInputType.name,
              label: "First Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.lastNameController,
              type: TextInputType.name,
              label: "Second Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your second name';
                }
                return null;
              },
            ),
            sizedBox(),
            DOBInputField(
              controller: widget.dobController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your date of birth';
                }
                return null;
              },
            ),
            sizedBox(),
            ImagePickerField(
              controller: widget.imageController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an image';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      height: 20,
    );
  }
}
