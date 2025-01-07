import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Widgets/dobInputField.dart';
import 'package:raithan_serviceapp/Widgets/dropDownTextFeild.dart';
import 'package:raithan_serviceapp/Widgets/imageInputFeild.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';

enum Gender { male, female, other }

class PersonalDetailsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController;
  final TextEditingController genderController;
  final TextEditingController
      imageController; // If image URI or path is stored as string

  const PersonalDetailsPage({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.dobController,
    required this.imageController,
    required this.genderController,
  });

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: widget.formKey,
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
            DropdownTextField(
              controller: widget.genderController,
              label: "Select an Gender",
              options: ['Male', 'Female', 'Other'],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
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
            sizedBox(),
          ],
        ),
      ),
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      height: 15,
    );
  }
}
