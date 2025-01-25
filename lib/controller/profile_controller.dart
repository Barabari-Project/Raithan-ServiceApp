
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/constants/api_constants.dart';
import 'package:raithan_serviceapp/dtos/file_with_media_type.dart';
import 'package:raithan_serviceapp/network/BaseApiServices.dart';
import 'package:raithan_serviceapp/network/NetworkApiService.dart';
import 'package:http_parser/http_parser.dart';

import '../Utils/utils.dart';
import '../constants/enums/custom_snackbar_status.dart';

class ProfileController extends GetxController {

  RxBool isEditAllowed = false.obs;
  RxBool isLoading = false.obs;
  RxBool savingProfileDetails = false.obs;
  RxString profileImage = "".obs;
  RxBool isImageUpdated = false.obs;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> profileDetailsFormKey = GlobalKey<FormState>();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode dobFocusNode = FocusNode();
  FocusNode genderFocusNode = FocusNode();

  final BaseApiServices baseApiServices = NetworkApiService();

  @override
  Future<void> onInit() async {
    super.onInit();
    dynamic response = await fetchUserProfileDetails();
    if(response != null)
      {

        firstNameController.value =
            TextEditingValue(text: response["provider"]["firstName"]);
        lastNameController.value =
            TextEditingValue(text: response["provider"]["lastName"]);
        dobController.value =
            TextEditingValue(text: response["provider"]["yearOfBirth"].toString());
        genderController.value =
            TextEditingValue(text: response["provider"]["gender"]);

        profileImage.value = response["provider"]["profilePicturePath"];


      }
  }

  @override
  void dispose() async {
    super.dispose();
    Utils.clearImageCache(profileImage.value);
  }


  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if(result != null)
      {
        await Utils.clearImageCache(profileImage.value);
        profileImage.value = result.files.first.path!;
        isImageUpdated.value = true;

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

  Future<void> saveUserProfilDetails(BuildContext context) async
  {

    if(!profileDetailsFormKey.currentState!.validate())
      {
        Utils.showSnackbar("Almost There!", "Please write valid Phone Number",
            CustomSnackbarStatus.warning);
        return;
      }

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    });

      // savingProfileDetails.value = true;
        Utils.showBackDropLoading(context);

       try {
         String filePath = profileImage.value;

         List<String> filePart = filePath.split(".");

         MediaType imageMediaType = MediaType(
             'image', filePart.last); // Assuming the file is a JPEG image

         dynamic images = isImageUpdated.value ? {'img': FileWithMediaType(File(filePath), imageMediaType)} : null;

         final response = await baseApiServices.postMultipartFilesUploadApiResponse(
             APIConstants.providerSaveProfileDetails,
             null,
             {
               'firstName': firstNameController.value.text,
               'lastName': lastNameController.value.text,
               'yearOfBirth': dobController.value.text,
               'gender': genderController.value.text,
             },
             images,
             true);

         isEditAllowed.value = false;
         Utils.showSnackbar("Yeah !", response?["message"], CustomSnackbarStatus.success);
         Navigator.of(context).pop();

       }  catch (e) {
         Navigator.of(context).pop();

         if (e is Exception) {
           Utils.handleException(e);
         } else {

           Utils.showSnackbar(
               "Oops !",
               "Some Thing Went Wrong Please Try Again Later !",
               CustomSnackbarStatus.error);
         }
       }
       finally{

       }
  }

  Future<dynamic> fetchUserProfileDetails() async
  {
     isLoading.value = true;

     try {
       dynamic response = await baseApiServices.getGetApiResponse(
           "${APIConstants.baseUrl}${APIConstants
               .providerGetProfileDetails}", null,
           true);
       return response;
     }
     catch (e)
     {
       print(e);
       if (e is Exception) {
         Utils.handleException(e);
       } else {
         Utils.showSnackbar(
             "Oops !",
             "Some Thing Went Wrong Please Try Again Later !",
             CustomSnackbarStatus.error);
       }
     }
     finally{
       isLoading.value = false;
     }

     return null;

  }

}