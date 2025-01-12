import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Widgets/dobInputField.dart';
import 'package:raithan_serviceapp/Widgets/dropDownTextFeild.dart';
import 'package:raithan_serviceapp/Widgets/imageInputFeild.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';
import 'package:raithan_serviceapp/constants/regex_constant.dart';

import '../../../Utils/utils.dart';

enum Gender { male, female, other }

class PersonalDetailsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController;
  final TextEditingController genderController;
  final TextEditingController imageController; // If image URI or path is stored as string

  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode dobFocusNode = FocusNode();
  final FocusNode genderFocusNode = FocusNode();
  final FocusNode imageFocusNode = FocusNode();


  PersonalDetailsPage({
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
      padding: EdgeInsets.only(top: AppDimensions.formFieldPadding, left: AppDimensions.formFieldPadding, right: AppDimensions.formFieldPadding),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Personal Details",
                  style: robotoBold.copyWith(
                    color: black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.firstNameController,
              type: TextInputType.name,
              label: "First Name",
              focusNode: widget.firstNameFocusNode,
              onFieldSubmitted: (value) {
                Utils.changeNodeFocus(
                    context,
                    widget.firstNameFocusNode,
                    widget.lastNameFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                if(!RegExp(RegexConstant.nameValidationRegex).hasMatch(value))
                  {
                    return 'First Name should contain only letter and space';
                  }
                else if(value.length <= 2)
                {
                  return "First Name length must be greater than 2";
                }
                return null;
              },
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.lastNameController,
              type: TextInputType.name,
              label: "Last Name",
              focusNode: widget.lastNameFocusNode,
              onFieldSubmitted: (value) {
                Utils.changeNodeFocus(
                    context,
                    widget.lastNameFocusNode,
                    widget.dobFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Last name';
                }
                if(!RegExp(RegexConstant.nameValidationRegex).hasMatch(value)) {
                  return 'Last Name should contain only letter and space';
                }
                else if(value.length <= 2)
                  {
                    return "Last Name length must be greater than 2";
                  }
                return null;
              },
            ),
            sizedBox(),
            DOBInputField(
              controller: widget.dobController,
              focusNode : widget.dobFocusNode,
              onFieldSubmitted: (value) {
                Utils.changeNodeFocus(
                    context,
                    widget.dobFocusNode,
                    widget.genderFocusNode);
              },
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
              focusNode: widget.genderFocusNode,
              onFieldSubmitted: (value) {
                 widget.genderFocusNode.unfocus();
              },
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
