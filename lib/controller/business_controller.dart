import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:raithan_serviceapp/constants/api_constants.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';
import 'package:raithan_serviceapp/dtos/file_with_media_type.dart';
import 'package:raithan_serviceapp/network/BaseApiServices.dart';
import 'package:raithan_serviceapp/network/NetworkApiService.dart';
import 'package:raithan_serviceapp/utils/storage.dart';

import '../Utils/utils.dart';
import '../constants/enums/custom_snackbar_status.dart';

class BusinessController extends GetxController {
  RxBool isEditAllowed = false.obs;
  RxBool isLoading = false.obs;
  RxBool savingProfileDetails = false.obs;
  RxString profileImage = "".obs;
  RxBool isImageUpdated = false.obs;



  dynamic businessDetails = {} ;
  dynamic businessAddress = {} ;
  dynamic businessTime = {} ;
  List<String> businessDays = List.empty() ;
  dynamic businessInfo = {};

  final ScrollController scrollController = ScrollController();

  Map<String, bool> workingDays = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };


  final BaseApiServices baseApiServices = NetworkApiService();



  @override
  Future<void> onInit() async {
    super.onInit();
    dynamic response = await fetchUserBusinessDetails();
    setBusinessDetails(response);
  }

  void setBusinessDetails(dynamic response)
  {
    try {
      isLoading.value = true;
      if (businessDetails != null) {

        businessInfo = response["business"];

        businessDays = response["business"]["workingDays"]
            .entries
            .where((mapEntry) => mapEntry.value == true) // Ensure you're comparing with a boolean value
            .map((mapEntry) => mapEntry.key.toString())
            .toList()
            .cast<String>();

        businessDetails  = {
          'Business Name': response["business"]["businessName"],
          'category' : response["business"]["category"].join(', ') };

        businessAddress = {   'Block Number': response["business"]["blockNumber"],
          'Street': response["business"]["street"],
          'Area': response["business"]["area"],
          'Landmark': response["business"]["landmark"],
          'City': response["business"]["city"],
          'State': response["business"]["state"],
          'Pincode': response["business"]["pincode"] };

        businessTime = {
          'Start Time' : response["business"]["workingTime"]['start'],
          'End Time' : response["business"]["workingTime"]['end'],
        };

        // print(businessDetails.length);
      }
    }  catch (e) {

    }
    finally{
      isLoading.value = false;
    }
  }

  void allowEditProfileDetails() {
    isEditAllowed.value = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    });
  }


  Future<void> saveUserBusinessDetails() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    });

    savingProfileDetails.value = true;

    try {
      String filePath = profileImage.value;

      List<String> filePart = filePath.split(".");

      MediaType imageMediaType = MediaType(
          'image', filePart.last); // Assuming the file is a JPEG image

      dynamic images = isImageUpdated.value
          ? {'img': FileWithMediaType(File(filePath), imageMediaType)}
          : null;

      final response =
          await baseApiServices.postMultipartFilesUploadApiResponse(
              APIConstants.providerSaveProfileDetails,
              null,
              {
                // 'firstName': firstNameController.value.text,
                // 'lastName': lastNameController.value.text,
                // 'yearOfBirth': dobController.value.text,
                // 'gender': genderController.value.text,
              },
              images,
              true);

      Utils.showSnackbar(
          "Yeah !", response?["message"], CustomSnackbarStatus.success);
    } catch (e) {
      if (e is Exception) {
        Utils.handleException(e);
      } else {
        print(e);
        Utils.showSnackbar(
            "Oops !",
            "Some Thing Went Wrong Please Try Again Later !",
            CustomSnackbarStatus.error);
      }
    } finally {
      savingProfileDetails.value = false;
      isEditAllowed.value = false;
    }
  }

  Future<dynamic> fetchUserBusinessDetails() async {
    isLoading.value = true;

    String? userId = await Storage.getValue(StorageKeys.USER_ID);
    try {
      dynamic response = await baseApiServices.getGetApiResponse(
          "${APIConstants.baseUrl}${APIConstants.providerGetBusinessDetails}${userId}",
          null,
          true);
      return response;
    } catch (e) {
      print(e);
      if (e is Exception) {
        Utils.handleException(e);
      } else {
        Utils.showSnackbar(
            "Oops !",
            "Some Thing Went Wrong Please Try Again Later !",
            CustomSnackbarStatus.error);
      }
    } finally {
      isLoading.value = false;
    }

    return null;
  }
}
