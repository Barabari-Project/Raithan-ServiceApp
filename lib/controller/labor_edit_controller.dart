import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/constants/enums/agriculture_labor_service_type.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/constants/enums/mechanic_service_type.dart';
import 'package:raithan_serviceapp/dtos/agriculture_dto.dart' hide AgricultureLaborServiceType;

import '../Utils/utils.dart';
import '../constants/api_constants.dart';
import '../constants/enums/custom_snackbar_status.dart';
import '../network/BaseApiServices.dart';
import '../network/NetworkApiService.dart';

class LaborEditController extends GetxController {

  RxBool isLoading = false.obs;

  RxBool savingBusinessDetails = false.obs;

  RxString businessType = "".obs;

  final TextEditingController shramCardController = TextEditingController();
  final TextEditingController numberOfWorkers = TextEditingController();
  final TextEditingController shramCardNumber = TextEditingController();


  final FocusNode numberOfWorkerFocusNode = FocusNode();
  final FocusNode shramCardNumberFocusNode = FocusNode();
  final FocusNode serviceTypeFocusNode = FocusNode();

  RxBool isIndividual = true.obs;
  RxBool readyToTravelIn10Km = true.obs;

  Map<String, bool> serviceTypes = {};


  final GlobalKey<FormState> laborDetailFormKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  final BaseApiServices baseApiServices = NetworkApiService();



  @override
  void onInit() {
    super.onInit();
    dynamic details = Get.arguments;
    businessType.value = details["businessType"];

    if(businessType.value == BusinessCategory.AGRICULTURE_LABOR.name) {
      serviceTypes = Map.fromEntries(
        AgricultureLaborServiceType.values.map((category) {
          return MapEntry(category.toString(), false);
        }),
      );
    }
    else if(businessType.value == BusinessCategory.MECHANICS.name){
      serviceTypes = Map.fromEntries(
        MechanicServiceType.values.map((category) {
          return MapEntry(category.toString(), false);
        }),
      );
    }

    dynamic productDetails = details["productDetails"];
    if (productDetails != null) {
      //TODO : set Product details in case of edit
    }
  }

  void setProductDetails(dynamic productDetails) {
    // Basicall here id will be exist so based on that we can add the details.
    // TODO :- here from productLIst controller find and add details in array, in case of udpate, update the details
  }

  void saveProductDetailsDetails(BuildContext context) async {
    if (!serviceTypes.containsValue(true)) {
      Utils.showSnackbar(
          "Almost There!",
          "Please select At least $businessType Service Type" ,
          CustomSnackbarStatus.warning);
      return;
    }

    if (laborDetailFormKey.currentState?.validate() ?? false) {
      try {



        final response = await baseApiServices.getPutApiResponse(
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
        savingBusinessDetails.value = false;
      }
    } else {
      Utils.showSnackbar("Almost There!", "Please write valid details",
          CustomSnackbarStatus.warning);
    }
  }
}
