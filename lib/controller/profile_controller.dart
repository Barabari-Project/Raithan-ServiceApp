

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if(pickedFile != null)
      {
        profileImagePath.value = pickedFile.path;
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


  void showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
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