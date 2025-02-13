import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:raithan_serviceapp/constants/api_constants.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';
import 'package:raithan_serviceapp/dtos/file_with_media_type.dart';
import 'package:raithan_serviceapp/network/BaseApiServices.dart';
import 'package:raithan_serviceapp/network/NetworkApiService.dart';
import 'package:raithan_serviceapp/utils/storage.dart';

import '../Utils/geo_position.dart';
import '../Utils/utils.dart';
import '../constants/enums/custom_snackbar_status.dart';

class BusinessController extends GetxController {
  RxBool isEditAllowed = false.obs;
  RxBool isLoading = false.obs;
  RxBool savingProfileDetails = false.obs;
  RxString profileImage = "".obs;
  RxBool isImageUpdated = false.obs;
  RxBool savingBusinessLocation = false.obs;

  bool updateLocation = false;


  dynamic businessDetails = {} ;
  dynamic businessAddress = {} ;
  dynamic businessTime = {} ;
  List<String> businessDays = List.empty() ;
  dynamic businessInfo = {};
  List<String> categories = List.empty();

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

  void askUpdateLocationConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Location'.tr),
          content: Text('updateLocationConfirmationText'.tr), // Question to ask
          actions: <Widget>[
            // "Yes" button
            TextButton(
              onPressed: () {
                updateLocation = false;
                Navigator.of(context).pop(false);
              },
              child: Text('No'.tr),
            ),
            // "No" button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'.tr),
            ),
          ],
        );
      },
    ).then((result) {
      if (result == true) {
        updateBusinessLocation(context);
      }
    });
  }

  void updateBusinessLocation(BuildContext context) async {

    Position? position;

    if(context.mounted)
    {
      Utils.showBackDropLoading(context);
    }

    try {
      position = await GeoPoistion.determinePosition();
    } catch (e) {
      Utils.showSnackbar("Almost There!", "Please Allow Location Permission",
          CustomSnackbarStatus.warning);
      Navigator.of(context).pop();
      return;
    }



    try {
      final response = await baseApiServices.getPostApiResponse(
          "${APIConstants.baseUrl}${APIConstants.providerCoordinates}",
          {
            'Content-Type': 'application/json',
          },
          jsonEncode({
            'lat': position.latitude,
            'lng': position.longitude
          }),
          null,
          true);
      Utils.showSnackbar(
          "Yeah !",
          response["message"],
          CustomSnackbarStatus.success);

      if(context.mounted){
        Navigator.of(context).pop();
      }
    }
    catch (e) {
      if(context.mounted){
        Navigator.of(context).pop();
      }
      if (e is Exception) {

        Utils.handleException(e);
      } else {
        Utils.showSnackbar(
            "Oops !",
            "Some Thing Went Wrong Please Try Again Later !",
            CustomSnackbarStatus.error);
      }
    }

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
          'Business Type' : response["business"]["businessType"]
         };

        categories = List<String>.from(response["business"]["category"]);

        if(categories.isEmpty)
          {
            categories.add("No products have been added yet, ".tr);
            categories.add("so no categories are available.".tr);
          }

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

      }
    }  catch (e) {
      Utils.showSnackbar(
          "Oops !",
          "Some Thing Went Wrong Please Try Again Later !",
          CustomSnackbarStatus.error);
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
