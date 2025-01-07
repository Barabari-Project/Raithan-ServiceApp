

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  RxBool isEditAllowed = false.obs;
  RxBool isProfileImageUpdated = false.obs;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final ScrollController scrollController = ScrollController();


  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode dobFocusNode = FocusNode();
  FocusNode genderFocusNode = FocusNode();

  RxString profileImagePath = 'assets/images/farm-background.jpg'.obs;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if(result != null)
      {
        profileImagePath.value = result.files.first.path!;
        isProfileImageUpdated.value = true;
      }
  }

  void allowEditProfileDetails()
  {
    isEditAllowed.value = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    });
  }



  Future<void> showYearPicker (BuildContext context) async
  {
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
            selectedDate: selectedDate,
            onChanged: (DateTime date) {
              dobController.value = TextEditingValue(text: date.year.toString());
              Navigator.pop(context);
            },
          ),
        ),
      ),
    ),
    );
  }

  void saveUserProfilDetails()
  {
       print(firstNameController.value.text);
       print(lastNameController.value.text);
       print(dobController.value.text);
       print(genderController.value.text);
  }

}