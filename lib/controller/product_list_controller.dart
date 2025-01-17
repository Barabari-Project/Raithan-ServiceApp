import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Widgets/products/harverstorItemCard.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/dtos/harverstor_dto.dart';

import '../Utils/utils.dart';
import '../Widgets/products/laborItemCard.dart';
import '../constants/api_constants.dart';
import '../constants/enums/custom_snackbar_status.dart';
import '../dtos/agriculture_dto.dart';

class ProductListController extends GetxController {
  RxBool isLoading = false.obs;

  final String businessType;

  ProductListController(this.businessType);

  List<AgricultureLabor> agricultureLaborItems = [];

  List<HarvestorDetails> harvestorDetails = [];

  @override
  void onInit() async
  {
    super.onInit();
    fetchAndSetProductDetails();
  }

  void fetchAndSetProductDetails() async
  {
    dynamic response = await fetchUserProductDetails();
    setAgricultureProductDetails(response);
  }

  void setAgricultureProductDetails(dynamic response)
  {
     if(businessType == BusinessCategory.AGRICULTURE_LABOR.name || businessType == BusinessCategory.MECHANICS.name)
       {
         if (response != null && response['products'] != null) {
           agricultureLaborItems = (response['products'] as List)
               .map((product) => AgricultureLabor.fromJson(product))
               .toList();
         }
       }
     else
       {
         if (response != null && response['products'] != null) {
           harvestorDetails = (response['products'] as List)
               .map((product) => HarvestorDetails.fromJson(product))
               .toList();
         }
       }
  }


  Future<dynamic> fetchUserProductDetails()async {
    isLoading.value = true;

    AuthController authController = Get.find();

    print(businessType);
    try {

      dynamic response = await authController.baseApiServices.getGetApiResponse(
          "${APIConstants.baseUrl}${APIConstants.providerGetProductsDetails}?category=$businessType",
          null,
          true);
      print(response);
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

  Widget getProductList()
  {

    if(businessType == BusinessCategory.AGRICULTURE_LABOR.name || businessType == BusinessCategory.MECHANICS.name)
    {
      return ListView.builder(
          itemCount: agricultureLaborItems.length,
          itemBuilder: (context, index) {
            return LaborItemCard(agricultureLabor: agricultureLaborItems[index]);
          });
    }
    else
    {
      return ListView.builder(
          itemCount: harvestorDetails.length,
          itemBuilder: (context, index) {
            return HarverstorItemCard( harvestorDetails : harvestorDetails[index]);
          });
    }
  }
}
