import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/constants/enums/agriculture_labor_service_type.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/constants/enums/mechanic_service_type.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/dtos/agriculture_dto.dart' hide AgricultureLaborServiceType;

import '../Utils/utils.dart';
import '../constants/api_constants.dart';
import '../constants/enums/custom_snackbar_status.dart';
import '../network/BaseApiServices.dart';
import '../network/NetworkApiService.dart';

class ProductEditController extends GetxController {

  RxBool isLoading = false.obs;

  RxBool savingProductDetails = false.obs;

  RxString businessType = "".obs;

  final TextEditingController frontViewImageController = TextEditingController();
  final TextEditingController leftViewImageController = TextEditingController();
  final TextEditingController backViewImageController = TextEditingController();
  final TextEditingController rightViewImageController = TextEditingController();
  final TextEditingController rcBookImageController = TextEditingController();
  final TextEditingController drivingLicenseImageController = TextEditingController();

  final TextEditingController hpController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController modelNoController = TextEditingController();

  final FocusNode hpFocusNode = FocusNode();
  final FocusNode typeFocusNode = FocusNode();
  final FocusNode modelNoFocusNode = FocusNode();

  final GlobalKey<FormState> productDetailsFormKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    dynamic details = Get.arguments;
    businessType.value = details["businessType"];

    dynamic productDetails = details["productDetails"];
    if (productDetails != null) {
      //TODO : set Product details in case of edit
    }
  }

  void setProductDetails(dynamic productDetails) {
    // Basicall here id will be exist so based on that we can add the details.
    // TODO :- here from productLIst controller find and add details in array, in case of udpate, update the details
  }

  void saveProductDetails(BuildContext context) async {

    if (productDetailsFormKey.currentState?.validate() ?? false) {
      savingProductDetails.value = true;
      try {

        AuthController authController = Get.find();

        final response = await authController.baseApiServices.getPutApiResponse(
            "${APIConstants.baseUrl}${APIConstants.providerSaveBusinessDetails}",
            {
              'Content-Type': 'application/json',
            },
            jsonEncode({}),
            null,
            true);


        setProductDetails(response);
        Utils.showSnackbar(
            "Yeah !", response["message"], CustomSnackbarStatus.success);
        Navigator.of(context).pop();
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
        savingProductDetails.value = false;
      }
    } else {
      Utils.showSnackbar("Almost There!", "Please write valid details",
          CustomSnackbarStatus.warning);
    }
  }
}
