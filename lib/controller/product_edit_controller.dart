import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/controller/product_list_controller.dart';
import 'package:raithan_serviceapp/dtos/file_with_media_type.dart';
import 'package:raithan_serviceapp/dtos/harverstor_dto.dart';

import '../Utils/utils.dart';
import '../constants/api_constants.dart';
import '../constants/enums/custom_snackbar_status.dart';

class ProductEditController extends GetxController {
  RxBool isLoading = false.obs;
  bool isEdit = false;

  RxBool savingProductDetails = false.obs;

  HarvestorDetails? oldProductDetails = null;

  RxString businessType = "".obs;

  final TextEditingController frontViewImageController =
      TextEditingController();
  final TextEditingController leftViewImageController = TextEditingController();
  final TextEditingController backViewImageController = TextEditingController();
  final TextEditingController rightViewImageController =
      TextEditingController();
  final TextEditingController rcBookImageController = TextEditingController();
  final TextEditingController drivingLicenseImageController =
      TextEditingController();

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
    isEdit = details['isEdit'] ?? false;
    if (isEdit) {
      oldProductDetails = details["productDetails"];
      setProductDetails(oldProductDetails!);
    }
  }

  void setEditedProductDetails(dynamic productDetails)
  {
     ProductListController productListController = Get.find();
     var harvestorDetails = productListController.harvestorDetails;

     try {
       productListController.isLoading.value = true;
       if (isEdit) {
         // Update the existing details based on the _id field
         for (int i = 0; i < harvestorDetails.length; i++) {
           if (harvestorDetails[i].id == productDetails['_id']) {
             harvestorDetails[i] = HarvestorDetails.fromJson(productDetails);
             break;
           }
         }
       } else {
         harvestorDetails.add(HarvestorDetails.fromJson(productDetails));
       }
     } catch (e) {
       Utils.showSnackbar("Oops ", e.toString(), CustomSnackbarStatus.error);
     }
     finally{
       productListController.isLoading.value = false;
     }
  }
  
  void setProductDetails(HarvestorDetails productDetails) {
    // Basically here id will be exist so based on that we can add the details.

    frontViewImageController.value =
        TextEditingValue(text: productDetails.imageWithTitle["front-view"]!);
    leftViewImageController.value =
        TextEditingValue(text: productDetails.imageWithTitle["left-view"]!);
    backViewImageController.value =
        TextEditingValue(text: productDetails.imageWithTitle["back-view"]!);
    rightViewImageController.value =
        TextEditingValue(text: productDetails.imageWithTitle["right-view"]!);

    if (businessType.value == BusinessCategory.DRONES.name) {
      rcBookImageController.value =
          TextEditingValue(text: productDetails.imageWithTitle['bill']!);
    } else {
      rcBookImageController.value =
          TextEditingValue(text: productDetails.imageWithTitle['rc-book']!);
      drivingLicenseImageController.value = TextEditingValue(
          text: productDetails.imageWithTitle['driving-license']!);
    }

    modelNoController.value = TextEditingValue(text: productDetails.modelNo);
    typeController.value = TextEditingValue(text: productDetails.type);
    hpController.value = TextEditingValue(text: productDetails.hp);
  }

  void saveProductDetails(BuildContext context) async {
    if (productDetailsFormKey.currentState?.validate() ?? false) {


      Utils.showBackDropLoading(context);

      try {
        AuthController authController = Get.find();

        Map<String,String> body = {
          'modelNo': modelNoController.text,
          'category': businessType.value
        };

        if (businessType.value != BusinessCategory.DRONES.name) {
          body['hp'] = hpController.text;
        }

        if (businessType.value == BusinessCategory.DRONES.name ||
            businessType.value == BusinessCategory.HARVESTORS.name ||
            businessType.value == BusinessCategory.EARTH_MOVERS.name) {
          body['type'] = typeController.text;
        }

        if(isEdit)
          {
            body['id'] = oldProductDetails!.id;
          }

        Map<String,FileWithMediaType> images = {};

        if (!(isEdit &&
            oldProductDetails != null &&
            oldProductDetails?.imageWithTitle['front-view'] ==
                frontViewImageController.text)) {
          images['front-view'] = FileWithMediaType(
              File(frontViewImageController.text),
              MediaType(
                  'image', Utils.getFileType(frontViewImageController.text)));
        }

        if (!(isEdit &&
            oldProductDetails != null &&
            oldProductDetails?.imageWithTitle['back-view'] ==
                backViewImageController.text)) {
          images['back-view'] = FileWithMediaType(
              File(backViewImageController.text),
              MediaType(
                  'image', Utils.getFileType(backViewImageController.text)));
        }

        if (!(isEdit &&
            oldProductDetails != null &&
            oldProductDetails?.imageWithTitle['left-view'] ==
                leftViewImageController.text)) {
          images['left-view'] = FileWithMediaType(
              File(leftViewImageController.text),
              MediaType(
                  'image', Utils.getFileType(leftViewImageController.text)));
        }

        if (!(isEdit &&
            oldProductDetails != null &&
            oldProductDetails?.imageWithTitle['right-view'] ==
                rightViewImageController.text)) {
          images['right-view'] = FileWithMediaType(
              File(rightViewImageController.text),
              MediaType(
                  'image', Utils.getFileType(rightViewImageController.text)));
        }

        if (businessType.value == BusinessCategory.DRONES.name) {
          if (!(isEdit &&
              oldProductDetails != null &&
              oldProductDetails?.imageWithTitle['bill'] ==
                  rcBookImageController.text)) {
            images['bill'] = FileWithMediaType(
                File(rcBookImageController.text),
                MediaType(
                    'image', Utils.getFileType(rcBookImageController.text)));
          }
        } else {
          if (!(isEdit &&
              oldProductDetails != null &&
              oldProductDetails?.imageWithTitle['rc-book'] ==
                  rcBookImageController.text)) {
            images['rc-book'] = FileWithMediaType(
                File(rcBookImageController.text),
                MediaType(
                    'image', Utils.getFileType(rcBookImageController.text)));
          }
          if (!(isEdit &&
              oldProductDetails != null &&
              oldProductDetails?.imageWithTitle['driving-license'] ==
                  drivingLicenseImageController.text)) {
            images['driving-license'] = FileWithMediaType(
                File(drivingLicenseImageController.text),
                MediaType('image',
                    Utils.getFileType(drivingLicenseImageController.text)));
          }
        }


        String url = isEdit ? APIConstants.editProductDetails : APIConstants.saveProductDetails;

        if (businessType.value == BusinessCategory.DRONES.name) {
          url = isEdit ? APIConstants.editDroneDetails : APIConstants.saveDroneDetails;
        }

        final response = await authController.baseApiServices
            .postMultipartFilesUploadApiResponse(url, null, body, images, true, requestType: isEdit ? 'PUT' : 'POST');

        setEditedProductDetails(response!["product"]);
        Utils.showSnackbar(
            "Yeah !", response?["message"], CustomSnackbarStatus.success);
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
        Navigator.of(context).pop();
      }
    } else {
      Utils.showSnackbar("Almost There!", "Please write valid details",
          CustomSnackbarStatus.warning);
    }
  }
}
