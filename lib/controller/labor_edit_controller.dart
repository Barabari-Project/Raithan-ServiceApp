import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/constants/enums/agriculture_labor_service_type.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/constants/enums/mechanic_service_type.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/controller/product_list_controller.dart';
import 'package:raithan_serviceapp/dtos/agriculture_dto.dart' hide AgricultureLaborServiceType;

import '../Utils/utils.dart';
import '../constants/api_constants.dart';
import '../constants/enums/custom_snackbar_status.dart';
import '../dtos/file_with_media_type.dart';
import '../network/BaseApiServices.dart';
import '../network/NetworkApiService.dart';
import 'package:http_parser/http_parser.dart';


class LaborEditController extends GetxController {

  RxBool isLoading = false.obs;

  RxBool savingProductDetails = false.obs;

  RxString businessType = "".obs;

  bool isEdit = false;

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

  AgricultureLabor? oldAgricultureLabor = null;

  @override
  void onInit() {
    super.onInit();
    dynamic details = Get.arguments;

    businessType.value = details["businessType"];
    isEdit = details["isEdit"] ?? false;

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

    if(isEdit)
      {
        oldAgricultureLabor = details["productDetails"];
        setProductDetails(oldAgricultureLabor!);
      }

  }


  void setProductDetails(AgricultureLabor productDetails) {
        shramCardNumber.value = TextEditingValue(text: productDetails.eShramCardNumber);
        numberOfWorkers.value = TextEditingValue(text: productDetails.numberOfWorkers.toString());
        isIndividual.value = productDetails.isIndividual;
        readyToTravelIn10Km.value = productDetails.readyToTravelIn10Km;
        shramCardController.value = TextEditingValue(text: productDetails.imageWithTitle["e-shram-card"]!);

        for (var value in productDetails.services) {
            serviceTypes[value.serviceName] = true;
        }
  }

  void setEditedLaborDetails(dynamic laborDetails)
  {
    ProductListController productListController = Get.find();
    var agricultureLaborItems = productListController.agricultureLaborItems;

    try {
      productListController.isLoading.value = true;
      if (isEdit) {
        // Update the existing details based on the _id field
        for (int i = 0; i < agricultureLaborItems.length; i++) {
          if (agricultureLaborItems[i].id == laborDetails['_id']) {
            agricultureLaborItems[i] = AgricultureLabor.fromJson(laborDetails);
            break;
          }
        }
      } else {
        productListController.noProducts.value = false;
        agricultureLaborItems.add(AgricultureLabor.fromJson(laborDetails));
      }
    } catch (e) {
      Utils.showSnackbar("Oops ", e.toString(), CustomSnackbarStatus.error);
    }
    finally{
      productListController.isLoading.value = false;
    }
  }

  void saveProductDetailsDetails(BuildContext context) async {
    if (!serviceTypes.containsValue(true)) {
      Utils.showSnackbar(
          "Almost There!",
          "Please select At least $businessType Service Type" ,
          CustomSnackbarStatus.warning);
      return;
    }

    AuthController authController = Get.find();

    if (laborDetailFormKey.currentState?.validate() ?? false) {

      Utils.showBackDropLoading(context);

      String url = isEdit ? APIConstants.editLaborDetails : APIConstants.saveLaborDetails;

      Map<String,String> body = {
          'category' : businessType.value,
          'eShramCardNumber' : shramCardNumber.text,
          'readyToTravelIn10Km' : readyToTravelIn10Km.value.toString(),
          'isIndividual' : isIndividual.value.toString(),
          'numberOfWorkers' : numberOfWorkers.text == "" ? "0" : numberOfWorkers.text,
          'services' :  '[${serviceTypes.entries
              .where((element) => element.value) // Filter where value is true
              .map((element) => '"${element.key}"') // Add quotes to keys
              .join(", ")}]'
      };

        if(isEdit)
        {
            body['id'] = oldAgricultureLabor!.id;
        }

        Map<String,FileWithMediaType> images = {};

      if (!(isEdit &&
          oldAgricultureLabor != null &&
          oldAgricultureLabor?.imageWithTitle['e-shram-card'] ==
              shramCardController.text)) {
        images['e-shram-card'] = FileWithMediaType(
            File(shramCardController.text),
            MediaType(
                'image', Utils.getFileType(shramCardController.text)));
      }

      try {

        final response = await authController.baseApiServices
            .postMultipartFilesUploadApiResponse(url, null, body, images, true, requestType: isEdit ? 'PUT' : 'POST');

        setEditedLaborDetails(response!["product"]);
        Utils.showSnackbar("Yeah !", response?["message"], CustomSnackbarStatus.success);
        Navigator.of(context).pop();
        Navigator.of(context).pop();

      } catch (e) {
        Navigator.of(context).pop();
        if (e is Exception) {
          Utils.handleException(e);
        } else {
          Utils.showSnackbar(
              "Oops !",
              "Some Thing Went Wrong Please Try Again Later !",
              CustomSnackbarStatus.error);
        }
      } finally {

      }
    } else {
      Utils.showSnackbar("Almost There!", "Please write valid details",
          CustomSnackbarStatus.warning);
    }
  }
}
