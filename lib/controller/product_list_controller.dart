import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:raithan_serviceapp/Utils/app_colors.dart';
import 'package:raithan_serviceapp/Utils/geo_position.dart';
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/Widgets/products/harverstorItemCard.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/dtos/harverstor_dto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/utils.dart';
import '../Widgets/products/laborItemCard.dart';
import '../constants/api_constants.dart';
import '../constants/enums/custom_snackbar_status.dart';
import '../dtos/agriculture_dto.dart';

class ProductListController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool noProducts = true.obs;

  final String businessType;

  ProductListController(this.businessType);

  RxList<AgricultureLabor> agricultureLaborItems = <AgricultureLabor>[].obs;

  RxList<HarvestorDetails> harvestorDetails = <HarvestorDetails>[].obs;

  final GlobalKey<FormState> phoneNumberKey = GlobalKey<FormState>();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  final TextEditingController distanceController = TextEditingController();

  final TextEditingController horsePowerController = TextEditingController();

  bool isHorsePowerFilterApplicable = true;

  final GlobalKey<FormState> otpKey = GlobalKey<FormState>();

  late AuthController authController;

  String seekerAction = "";
  String serviceProviderId = "";
  String providerPhoneNumber = "";
  String providerProductId = "";
  double seekerRating = 0;

  @override
  void onInit() async {
    super.onInit();

    distanceController.value = const TextEditingValue(text: "5 Km");

    horsePowerController.value = const TextEditingValue(text: "25 Hp");

    if(businessType == BusinessCategory.DRONES.name || businessType == BusinessCategory.AGRICULTURE_LABOR.name ||
       businessType == BusinessCategory.MECHANICS.name)
      {
          isHorsePowerFilterApplicable = false;
      }

    authController = Get.find();

    fetchAndSetProductDetails();
  }

  void fetchAndSetProductDetails() async {
    AuthController authController = Get.find();

    dynamic products;

    if (authController.userRole.value == 'PROVIDER') {
      dynamic response = await fetchUserProductDetails();
      products = response['products'];
    } else {
      isLoading.value = true;

      try {
        Position? position = await GeoPoistion.determinePosition();

        dynamic response = await fetchUserProductDetailsForSeekers(
            position.latitude, position.longitude);

        products = response['productList'];
      } catch (e) {
        Utils.showSnackbar("Almost There!", "Please Allow Location Permission",
            CustomSnackbarStatus.warning);
        return;
      } finally {
        isLoading.value = false;
      }
    }

    setProductDetails(products);
  }

  void setProductDetails(dynamic products) {
    print(products);
    if (products == null || (products as List).isEmpty) {
      noProducts.value = true;
      return;
    } else {
      noProducts.value = false;
    }

    if (businessType == BusinessCategory.AGRICULTURE_LABOR.name ||
        businessType == BusinessCategory.MECHANICS.name) {
      agricultureLaborItems.value = (products)
          .map((product) => AgricultureLabor.fromJson(product))
          .toList();
    } else {
      harvestorDetails.value = products
          .map((product) => HarvestorDetails.fromJson(product))
          .toList();
    }

    noProducts.value = false;
  }

  Future<dynamic> fetchUserProductDetails() async {
    isLoading.value = true;

    AuthController authController = Get.find();

    try {
      dynamic response = await authController.baseApiServices.getGetApiResponse(
          "${APIConstants.baseUrl}${APIConstants.providerGetProductsDetails}?category=$businessType",
          null,
          true);
      return response;
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
      isLoading.value = false;
    }

    return null;
  }

  Future<dynamic> fetchUserProductDetailsForSeekers(double latitude, double longitude) async {
    isLoading.value = true;

    AuthController authController = Get.find();

    latitude = 23.025141;
    longitude = 72.542791;

    Map<String, Object> requestBody = {
      'lat': latitude,
      'lng': longitude,
      'distance': distanceController.text.split(" ")[0],
      'category': businessType.toString()
    };

    if (businessType != BusinessCategory.DRONES.name &&
        businessType != BusinessCategory.AGRICULTURE_LABOR.name &&
        businessType != BusinessCategory.MECHANICS.name) {
      requestBody['hp'] = horsePowerController.text.split(" ")[0];
    }

    try {
      dynamic response =
          await authController.baseApiServices.getPostApiResponse(
              "${APIConstants.baseUrl}${APIConstants.seekerGetProductsDetails}",
              {
                'Content-Type': 'application/json',
              },
              jsonEncode(requestBody),
              null,
              false);

      return response;
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
      isLoading.value = false;
    }
    return null;
  }

  List<Widget> getProductList() {
    if (businessType == BusinessCategory.AGRICULTURE_LABOR.name ||
        businessType == BusinessCategory.MECHANICS.name) {
      return agricultureLaborItems.map((item) {
        return LaborItemCard(
          agricultureLabor: item,
          businessType: businessType,
        );
      }).toList();
    } else {
      return harvestorDetails.map((item) {
        return HarverstorItemCard(
          harvestorDetails: item,
          businessType: businessType,
        );
      }).toList();
    }
  }

  void seekerInquiryCall(BuildContext parentContext, String providerPhoneNumber,String serviceProviderId)
  {
     if(authController.activeSession.value)
       {
         navigateToDialer(providerPhoneNumber);
         seekerCallEvent(serviceProviderId);
         return;
       }
      seekerAction = "CALL";
     this.providerPhoneNumber = providerPhoneNumber;
     this.serviceProviderId = serviceProviderId;
     initiateSeekerLoginProcess(parentContext);
  }

  void initiateSeekerLoginProcess(BuildContext parentContext) {

    if(authController.activeSession.value)
      {
         navigateToDialer(providerPhoneNumber);
         seekerCallEvent(serviceProviderId);
         return;
      }

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Write Your Phone Number".tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We will send you an OTP to verify your phone number.".tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: phoneNumberKey,
                child: TextFormField(
                  maxLength: 10,
                  controller: phoneNumberController,
                  buildCounter: (context,
                          {required currentLength,
                          maxLength,
                          required isFocused}) =>
                      null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number'.tr;
                    }
                    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                      return 'Please enter a valid phone number'.tr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: AppColors.appBarColor),
                    hintText: "Write Your Phone Number".tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.appBarColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.appBarColor, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (phoneNumberKey.currentState?.validate() ?? false) {
                    Navigator.pop(context);
                    sendSeekerOTP(parentContext,phoneNumberController.text);
                  }
                  // Close the bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appBarColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "Submit".tr,
                  style: const TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void sendSeekerOTP(BuildContext context, String phoneNumber) async {

    Utils.showBackDropLoading(context);

    AuthController authController = Get.find();

    print(phoneNumber);
    try {

      dynamic response = await authController.baseApiServices.getPostApiResponse(
          "${APIConstants.baseUrl}${APIConstants.seekerLoginSentOTP}",
          {
            'Content-Type': 'application/json',
          },
          jsonEncode({'mobileNumber' : "+91$phoneNumber"}),
          null,
          false);

      print(response);
      Utils.showSnackbar("Yeah !", response["message"], CustomSnackbarStatus.success);

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      showOTPPage(context, phoneNumber);

    } catch (e) {
      if (e is Exception) {
        Utils.handleException(e);
      } else {
        Utils.showSnackbar(
            "Oops !",
            "Some Thing Went Wrong Please Try Again Later !",
            CustomSnackbarStatus.error);
      }

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void showOTPPage(BuildContext parentContext, String phoneNumber) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "Enter OTP".tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We have sent a 6-digit OTP to your phone number.".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Form(
                  key: otpKey,
                  child: Pinput(
                    length: 6,
                    controller: otpController,
                    defaultPinTheme: PinTheme(
                      width: 48,
                      height: 48,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 48,
                      height: 48,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        Utils.showSnackbar("Oops !", 'Please enter the OTP'.tr,CustomSnackbarStatus.warning );
                        return 'Please enter the OTP'.tr;
                      }
                      if (value?.length != 6 ||
                          !RegExp(r'^[0-9]{6}$').hasMatch(value!)) {
                        Utils.showSnackbar("Oops !", 'OTP must be 6 digits'.tr,CustomSnackbarStatus.warning );
                        return 'OTP must be 6 digits'.tr;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if(otpKey.currentState!.validate())
                    {
                      verifyOTP(parentContext, context, otpController.text, phoneNumber);
                    }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appBarColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  "Submit".tr,
                  style: const  TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 18,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void verifyOTP(BuildContext parentContext, BuildContext context, String otp, String phoneNumber) async {

    try {

      Utils.showBackDropLoading(context);

      dynamic response = await authController.baseApiServices.getPostApiResponse(
          "${APIConstants.baseUrl}${APIConstants.seekerLoginVerifyOTP}",
          {
            'Content-Type': 'application/json',
          },
          jsonEncode({
            "mobileNumber" : "+91$phoneNumber",
            "code":  otp
          }),
          null,
          false );

      Storage.saveValue(StorageKeys.JWT_TOKEN, response["token"]);
      Storage.saveValue(StorageKeys.USER_ROLE, "SEEKER");

      authController.activeSession.value = true;

      if(seekerAction == "CALL") {
        seekerCallEvent(serviceProviderId);
        navigateToDialer(providerPhoneNumber);
      }
      else{
        saveUserFeedBackRating(parentContext, providerProductId ,seekerRating);
      }

      Utils.showSnackbar("Yeah ", response["message"], CustomSnackbarStatus.success);
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
    }
    finally{

    }

    if (context.mounted) {
      Navigator.of(parentContext).pop();
    }



  }

  void navigateToDialer(String providerPhoneNumber) async
  {
    final Uri dialerUri = Uri(
      scheme: 'tel',
      path: providerPhoneNumber,
    );

        if (await canLaunchUrl(dialerUri)) {
      await launchUrl(dialerUri);
      } else {
      Utils.showSnackbar("Oops ", "Not able to launch dialer", CustomSnackbarStatus.error);
      }
  }


  Future<void> seekerCallEvent(String serviceProviderId) async
  {
     try{

       await authController.baseApiServices.getPostApiResponse(
           "${APIConstants.baseUrl}${APIConstants.seekerCallEvent}",
           {
             'Content-Type': 'application/json',
           },
           jsonEncode({
             "serviceProviderId" : serviceProviderId
           }),
           null,
           true);
     }
     catch(e)
    {

    }
  }


  void showFeedBackSheet(BuildContext parentContext, String productId)
  {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        double rating = 0; // Holds the current rating value

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Provide Your Feedback".tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please rate your experience with the service.".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 5-Star Rating System
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0; // Update the rating
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Submit the rating and close the modal
                      Navigator.pop(context);
                      seekerRateUs(parentContext, productId, rating);

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appBarColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Submit".tr,
                      style: const TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

  }


  void seekerRateUs(BuildContext context,String productId, double rating)
  {
     if(authController.activeSession.value)
       {
         saveUserFeedBackRating(context, productId, rating);
       }
     else{
       seekerAction = "RATING";
       providerProductId = productId;
       seekerRating = rating;
       initiateSeekerLoginProcess(context);
     }
  }

  void saveUserFeedBackRating(BuildContext parentContext, String productId, double rating ) async
  {
    Utils.showBackDropLoading(parentContext);
    try {
      dynamic response = await authController.baseApiServices
          .getPostApiResponse(
          "${APIConstants.baseUrl}${APIConstants.seekerRating}",
          {
            'Content-Type': 'application/json',
          },
          jsonEncode({
            "productId": productId,
            "rating": rating,
            "category": businessType
          }),
          null,
          true);

      if(businessType == BusinessCategory.AGRICULTURE_LABOR.name || businessType == BusinessCategory.MECHANICS.name)
      {
          for(AgricultureLabor agricultureLabor in agricultureLaborItems)
            {
               if(agricultureLabor.id == productId)
                 {
                   agricultureLabor.avgRating.value = (response["avgRating"] as num).toDouble();
                 }
            }
      }
      else{
        for(HarvestorDetails harvestorDetail in harvestorDetails)
        {
          if(harvestorDetail.id == productId)
          {
            harvestorDetail.avgRating.value = (response["avgRating"] as num).toDouble();
          }
        }
      }

      Utils.showSnackbar(
          "Yeah !", response["message"], CustomSnackbarStatus.success);
      Navigator.of(parentContext).pop();
    } catch (e) {
      Navigator.of(parentContext).pop();
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


}
