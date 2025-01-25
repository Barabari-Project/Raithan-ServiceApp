import 'dart:convert';
import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Utils/geo_position.dart';
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/constants/api_constants.dart';
import 'package:raithan_serviceapp/constants/enums/custom_snackbar_status.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';

import '../../controller/auth_controller.dart';
import '../../dtos/file_with_media_type.dart';
import '../../network/BaseApiServices.dart';
import '../../network/NetworkApiService.dart';
import 'Pages/businessDetailsPage.dart';
import 'Pages/otpPage.dart';
import 'Pages/personalDetailsPage.dart';
import 'Pages/phonePage.dart';
import 'login.dart';

class Registration extends StatefulWidget {
  final String? phone;
  const Registration({
    super.key,
    this.phone,
  });

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  int currentPhase = 0;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _blockNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _workingDaysController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();

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


// Define the working time controllers (start and end time)
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _detailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _businessDetailFormKey = GlobalKey<FormState>();

  BaseApiServices baseApiServices = NetworkApiService();

  bool isLoading = false; // Add loading state

  void _showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  final GlobalKey _containerKeyHero = GlobalKey();

  final GlobalKey _containerKeyNextButton = GlobalKey();
  double containerHeroHeight = 0;
  double containerNextButtonHeight = 0;

  void _submitPhone(BuildContext context) async {
    if (_phoneFormKey.currentState?.validate() ?? false || currentPhase == 1) {

      Utils.showBackDropLoading(context);

      String phoneNumber = _phoneController.text;

      try {
        final response = await baseApiServices.getPostApiResponse(
            "${APIConstants.baseUrl}${APIConstants.providerSentOTP}",
            {
              'Content-Type': 'application/json',
            },
            jsonEncode({'mobileNumber': "+91$phoneNumber"}),
            null,
            false);

        setState(() {currentPhase = 1;});
        Storage.saveValue(StorageKeys.CURRENT_PHASE, "1");

        Utils.showSnackbar("Yeah !", response["message"], CustomSnackbarStatus.success);
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
      Utils.showSnackbar("Almost There!", "Please write valid Phone Number", CustomSnackbarStatus.warning);
    }
  }

  void _submitOtp(BuildContext context) async {
    if (_otpFormKey.currentState?.validate() ?? false) {

      Utils.showBackDropLoading(context);

      try {
        final response = await baseApiServices.getPostApiResponse(
            "${APIConstants.baseUrl}${APIConstants.providerRegistartionVerifyOTP}",
            {
              'Content-Type': 'application/json',
            },
            jsonEncode({
              'mobileNumber': "+91${_phoneController.text}",
              'code': _otpController.text,
            }),
            null,
            false);

        String jwtToken = response['token'];
        Storage.saveValue(StorageKeys.JWT_TOKEN, jwtToken);
        Utils.showSnackbar(
            "Yeah !", response["message"], CustomSnackbarStatus.success);

        Storage.saveValue(StorageKeys.CURRENT_PHASE, "2");
        Storage.saveValue(StorageKeys.USER_ROLE, "PROVIDER");

        setState(() {
          currentPhase = 2;
        });
        Storage.saveValue(StorageKeys.CURRENT_PHASE, "2");
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

      Utils.showSnackbar("Almost There!", "Please write valid OTP",
          CustomSnackbarStatus.warning);
    }
  }

  void _submitDetails(BuildContext context) async {
    if (_detailFormKey.currentState?.validate() ?? false) {
      Utils.showBackDropLoading(context);
      try {
        String filePath = _imageController.text;

        List<String> filePart = filePath.split(".");

        MediaType imageMediaType = MediaType(
            'image', filePart.last); // Assuming the file is a JPEG image

        final response =
            await baseApiServices.postMultipartFilesUploadApiResponse(
                APIConstants.providerSaveProfileDetails,
                null,
                {
                  'firstName': _firstNameController.text,
                  'lastName': _lastNameController.text,
                  'yearOfBirth': _dobController.text,
                  'gender': _genderController.text,
                },
                {'img': FileWithMediaType(File(filePath), imageMediaType)},
                true);

        Storage.saveValue(StorageKeys.USER_ID, response?["provider"]["_id"]);
        Storage.saveValue(StorageKeys.CURRENT_PHASE, "3");
        Utils.showSnackbar("Yeah !", response?["message"], CustomSnackbarStatus.success);

        setState(() {
          currentPhase = 3;
        });
        Storage.saveValue(StorageKeys.CURRENT_PHASE, "3");
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

  void _submitBusinessDetails(BuildContext context) async {

    if (_businessDetailFormKey.currentState?.validate() ?? false) {

      Utils.showBackDropLoading(context);

      scrollController.animateTo(
        0, // Scroll to top (offset 0)
        duration: Duration(milliseconds: 300), // Smooth scroll duration
        curve: Curves.easeInOut, // Scroll curve
      );

      Position? position;

      try {
        position = await GeoPoistion.determinePosition();
      }  catch (e) {
        Utils.showSnackbar("Almost There!", "Please Allow Location Permission",
            CustomSnackbarStatus.warning);
        Navigator.of(context).pop();
        return;
      }


      try {
        Map<String, String> workingTime = {
          "start": _startTimeController.text,
          "end": _endTimeController.text,
        };

        Map<String, dynamic> businessDetails = {
          "businessName": _businessNameController.text,
          "pincode": _pincodeController.text,
          "blockNumber": _blockNumberController.text,
          "street": _streetController.text,
          'businessType' : _businessTypeController.text,
          "area": _areaController.text,
          "landmark": _landmarkController.text,
          "city": _cityController.text,
          "state": _stateController.text,
          "workingDays": workingDays,
          "workingTime": workingTime,
          "location" : {
            'lat' : position.latitude,
            'lng' : position.longitude
          }
        };

        final response = await baseApiServices.getPostApiResponse(
            "${APIConstants.baseUrl}${APIConstants.providerSaveBusinessDetails}",
            {
              'Content-Type': 'application/json',
            },
            jsonEncode(businessDetails),
            null,
            true);


        Utils.showSnackbar(
            "Yeah !", response["message"], CustomSnackbarStatus.success);

        AuthController authController = Get.find();
        authController.activeSession.value = true;
        authController.userRole.value = "PROVIDER";
        Storage.removeKey(StorageKeys.CURRENT_PHASE);
        Get.offAllNamed(RouteName.provider_home);

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

        Navigator.of(context).pop();
      }

    } else {
      Utils.showSnackbar("Almost There!", "Please write valid details",
          CustomSnackbarStatus.warning);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.phone != null) {
      setState(() {
        _phoneController.text = widget.phone!;
      });
    }
   setCurrentPhase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBoxHero =
          _containerKeyHero.currentContext?.findRenderObject() as RenderBox;
      final RenderBox renderBoxNextButton =
          _containerKeyNextButton.currentContext?.findRenderObject()
              as RenderBox;

      setState(() {
        containerHeroHeight = renderBoxHero.size.height;
        containerNextButtonHeight = renderBoxNextButton.size.height;
      });
    });
  }

  @override
  void dispose()
  {
    // Dispose all TextEditingControllers
    _phoneController.dispose();
    _otpController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _imageController.dispose();
    _genderController.dispose();

    _businessNameController.dispose();
    _pincodeController.dispose();
    _blockNumberController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _workingDaysController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _businessTypeController.dispose();

    scrollController.dispose();

    super.dispose();
  }
  void setCurrentPhase() async{
    String? value = await Storage.getValue(StorageKeys.CURRENT_PHASE);
    if(value != null &&( value.length > 0))
      {
         setState(() {
           currentPhase = int.parse(value);
         });
      }
  }

  Widget getLineProgressWidget(int currentPhase, int stepNumber) {
    if (stepNumber == currentPhase) {
      return const DottedLine(
        dashColor: Colors.green,
        dashLength: 3.0,
        dashGapLength: 4.0,
        lineThickness: 2.0,
      );
    } else if (stepNumber > currentPhase) {
      return const DottedLine(
        dashColor: Colors.grey,
        dashLength: 3.0,
        dashGapLength: 4.0,
        lineThickness: 2.0,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    final double screenHeight = MediaQuery.of(context).size.height;

    dynamic currentPage;

    if (currentPhase == 0) {
      currentPage = PhonePage(
        phoneController: _phoneController,
        formKey: _phoneFormKey,
      );
    } else if (currentPhase == 1) {
      currentPage = OtpPage(
          phone: _phoneController.text,
          otpController: _otpController,
          sentOtp : _submitPhone,
          formKey: _otpFormKey);
    } else if (currentPhase == 2) {
      currentPage = PersonalDetailsPage(
        firstNameController: _firstNameController,
        lastNameController: _lastNameController,
        dobController: _dobController,
        imageController: _imageController,
        genderController: _genderController,
        formKey: _detailFormKey,
      );
    } else {
      currentPage = Businessdetailspage(
        businessNameController: _businessNameController,
        pincodeController: _pincodeController,
        blockNumberController: _blockNumberController,
        streetController: _streetController,
        areaController: _areaController,
        landmarkController: _landmarkController,
        cityController: _cityController,
        stateController: _stateController,
        startTimeController: _startTimeController,
        businessTypeController: _businessTypeController,
        // New parameter
        endTimeController: _endTimeController,
        workingDaysController: _workingDaysController,
        workingDays: workingDays,
        formKey: _businessDetailFormKey,
      );
    }

    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Stack(
          children: [
            Column(
              children: [
                // Header Section
                if (!(isKeyboardVisible && currentPhase == 2))
                  Container(
                    key: _containerKeyHero,
                    // height: 250,
                    padding: const EdgeInsets.only(
                        top: AppDimensions.auth_screen_top_padding,
                        left: AppDimensions.auth_screen_padding,
                        right: AppDimensions.auth_screen_padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome'.tr,
                          style: robotoNormal.copyWith(
                              color: Colors.white38,
                              fontSize: AppDimensions.largeFontSize),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Sign Up'.tr,
                          style: robotoBold.copyWith(
                            color: white,
                            fontSize: AppDimensions.extraLargeFontSize*1.5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: 'Already Registered? '.tr,
                            style: robotoNormal.copyWith(
                              color: white,
                              fontSize: AppDimensions.regularFontSize,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In'.tr,
                                style: robotoBold.copyWith(
                                  color: Colors.blue,
                                  // Different color for "Login"
                                  fontSize: AppDimensions.regularFontSize,
                                  decoration: TextDecoration
                                      .underline, // Underline for emphasis
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Stepper Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StepItemText(
                              stepNumber: 1,
                              label: "Phone  ".tr,
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            StepItemText(
                              stepNumber: 2,
                              label: ' OTP  '.tr,
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            StepItemText(
                              stepNumber: 3,
                              label: '   Profile'.tr,
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            StepItemText(
                              stepNumber: 4,
                              label: 'Business'.tr,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StepItem(
                              stepNumber: 1,
                              label: 'Phone'.tr,
                              currentPhase: currentPhase,
                            ),
                            Expanded(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5, top: 3),
                                  child:
                                      getLineProgressWidget(currentPhase, 0)),
                            ),
                            StepItem(
                              stepNumber: 2,
                              label: 'OTP'.tr,
                              currentPhase: currentPhase,
                            ),
                            Expanded(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5, top: 3),
                                  child:
                                      getLineProgressWidget(currentPhase, 1)),
                            ),
                            StepItem(
                              stepNumber: 3,
                              label: 'Details',
                              currentPhase: currentPhase,
                            ),
                            Expanded(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5, top: 3),
                                  child:
                                      getLineProgressWidget(currentPhase, 2)),
                            ),
                            StepItem(
                              stepNumber: 4,
                              label: 'Business',
                              currentPhase: currentPhase,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30), // Dynamic Content Section

                Container(
                  // height: screenHeight - containerHeroHeight - 30 - containerNextButtonHeight - AppDimensions.auth_screen_top_padding,
                  constraints: BoxConstraints(
                      minHeight: screenHeight -
                          containerHeroHeight -
                          containerNextButtonHeight - 30 -
                          AppDimensions.auth_screen_top_padding),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(92, 248, 244, 244),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F4F4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: currentPage,
                  ),
                ), // Footer Buttons
                Container(
                  key: _containerKeyNextButton,
                  padding: EdgeInsets.only(left : AppDimensions.formFieldPadding, right: AppDimensions.formFieldPadding, bottom: AppDimensions.formFieldPadding),
                  color: white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      if (currentPhase == 1 || currentPhase == 2 || currentPhase == 3)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                currentPhase = 0;
                              });
                            },
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.black,
                          ),
                        ),
                      // Next Button
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (currentPhase == 0) {
                                  _submitPhone(context);
                                } else if (currentPhase == 1) {
                                  _submitOtp(context);
                                } else if (currentPhase == 2) {
                                  _submitDetails(context);
                                } else {
                                  _submitBusinessDetails(context);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Next'.tr,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                const Icon(Icons.arrow_forward,size: 22,color: Colors.black,weight: 1,)
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Material(
                      //     child: InkWell(
                      //       onTap:() {
                      //         setState(() {
                      //           if (currentPhase == 0) {
                      //             _submitPhone(context);
                      //           } else if (currentPhase == 1) {
                      //             _submitOtp();
                      //           } else if (currentPhase == 2) {
                      //             _submitDetails();
                      //           } else {
                      //             _submitBusinessDetails();
                      //           }
                      //         });
                      //       } ,
                      //       child: Container(
                      //         height: 50,
                      //         decoration: BoxDecoration(
                      //           color: Colors.green,
                      //           borderRadius: BorderRadius.circular(12),
                      //         ),
                      //         child: const Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               const Text(
                      //                 ' Next',
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 18,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               SizedBox(width: 5,),
                      //               Icon(Icons.arrow_forward,size: 22.0,),
                      //             ],
                      //                                                )
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Step Item Widget
class StepItem extends StatelessWidget {
  final int stepNumber;
  final String label;
  final int currentPhase;

  const StepItem({
    super.key,
    required this.stepNumber,
    required this.label,
    required this.currentPhase,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Column(
          children: [
            SizedBox(
              width: 30,
            )
          ],
        ),
        const SizedBox(height: 5),
        CircleAvatar(
          radius: 10,
          backgroundColor:
              currentPhase <= stepNumber - 1 ? black : Colors.green,
          child: (currentPhase > stepNumber - 1)
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 10,
                )
              : (currentPhase == stepNumber - 1)
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
        ),
      ],
    );
  }
}

class StepItemText extends StatelessWidget {
  final int stepNumber;
  final String label;

  const StepItemText({
    super.key,
    required this.stepNumber,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
