

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/controller/business_controller.dart';

import '../Utils/utils.dart';
import '../constants/api_constants.dart';
import '../constants/enums/custom_snackbar_status.dart';
import '../network/BaseApiServices.dart';
import '../network/NetworkApiService.dart';

class BusinessEditController extends GetxController{

  RxBool isLoading = false.obs;
  RxBool savingBusinessDetails = false.obs;

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController blockNumberController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController workingDaysController = TextEditingController();

  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final GlobalKey<FormState> businessDetailFormKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  final BaseApiServices baseApiServices = NetworkApiService();

  Map<String, bool> workingDays = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };

  @override
  void onInit() {
    super.onInit();
    dynamic businessDetails = Get.arguments;
    if(businessDetails != null)
      {
        businessNameController.value = TextEditingValue(text: businessDetails["businessName"]);
     blockNumberController.value = TextEditingValue(text: businessDetails["blockNumber"]);
    streetController.value = TextEditingValue(text: businessDetails["street"]);
    areaController.value = TextEditingValue(text: businessDetails["area"] );
    landmarkController.value = TextEditingValue(text: businessDetails["landmark"]);
    cityController.value = TextEditingValue(text: businessDetails["city"] );
    stateController.value = TextEditingValue(text: businessDetails["state"]);
    pincodeController.value = TextEditingValue(text: businessDetails["pincode"]);
    categoryController.value = TextEditingValue(text: businessDetails["category"][0]);

    workingDays = Map<String, bool>.from(businessDetails["workingDays"] ?? {});


    startTimeController.value = TextEditingValue(text: businessDetails["workingTime"]['start']);
    endTimeController.value = TextEditingValue(text: businessDetails["workingTime"]['end']);
      }
  }

  void setBusinessDetails(dynamic businessDetails)
  {
      BusinessController businessController = Get.find();
      businessController.setBusinessDetails(businessDetails);
  }

  void saveBusinessDetails() async
  {

    if (businessDetailFormKey.currentState?.validate() ?? false) {

      try {
        Map<String, String> workingTime = {
          "start": startTimeController.text,
          "end": endTimeController.text,
        };

        Map<String, dynamic> businessDetails = {
          "businessName": businessNameController.text,
          "pincode": pincodeController.text,
          "blockNumber": blockNumberController.text,
          "street": streetController.text,
          "area": areaController.text,
          "landmark": landmarkController.text,
          "city": cityController.text,
          "state": stateController.text,
          "workingDays": workingDays,
          "workingTime": workingTime,
          "category": categoryController.text,
        };
        final response = await baseApiServices.getPutApiResponse(
            "${APIConstants.baseUrl}${APIConstants.providerSaveBusinessDetails}",
            {
              'Content-Type': 'application/json',
            },
            jsonEncode(businessDetails),
            null,
            true);


        Get.back();
        setBusinessDetails(response);
        Utils.showSnackbar("Yeah !", response["message"], CustomSnackbarStatus.success);

      } catch (e) {

        if (e is Exception) {
          Utils.handleException(e);
        } else {
          Utils.showSnackbar(
              "Oops !",
              "Some Thing Went Wrong Please Try Again Later !",
              CustomSnackbarStatus.error);
        }
      } finally {
        savingBusinessDetails.value = false;
      }
    } else {
       print("not valid");
      Utils.showSnackbar("Almost There!", "Please write valid details", CustomSnackbarStatus.warning);
    }
  }

}