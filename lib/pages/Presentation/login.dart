import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/constants/api_constants.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/pages/Presentation/registration.dart';

import '../../Utils/app_dimensions.dart';
import '../../Utils/storage.dart';
import '../../Utils/utils.dart';
import '../../constants/enums/custom_snackbar_status.dart';
import '../../constants/routes/route_name.dart';
import '../../constants/storage_keys.dart';
import '../../network/BaseApiServices.dart';
import '../../network/NetworkApiService.dart';
import 'Pages/otpPage.dart';
import 'Pages/phonePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int currentPhase = 0;
  bool isLoading = false;

  BaseApiServices baseApiServices = NetworkApiService();


  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  final GlobalKey _containerKeyHero = GlobalKey();
  final GlobalKey _containerKeyNextButton = GlobalKey();
  double containerHeroHeight = 0;
  double containerNextButtonHeight = 0;



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

  void _submitPhone(BuildContext context) async {
    if (_phoneFormKey.currentState?.validate() ?? false) {
      _showLoading();

      try {

        final response = await baseApiServices.getPostApiResponse(
            "${APIConstants.baseUrl}${APIConstants.providerLoginSentOTP}",
            {
              'Content-Type': 'application/json',
            },
            jsonEncode({'mobileNumber': "+91${_phoneController.text}"}),
            null,
            false);

        Utils.showSnackbar("Yeah !", response["message"], CustomSnackbarStatus.success);

        setState(() {
          currentPhase = 1;
        });
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
        _hideLoading();
      }
    } else {
      Utils.showSnackbar("Almost There!", "Please write valid Phone Number",
          CustomSnackbarStatus.warning);
    }
  }

  void _submitOtp() async {
    if (_otpFormKey.currentState?.validate() ?? false) {
      _showLoading();
      try {

        final response = await baseApiServices.getPostApiResponse(
            "${APIConstants.baseUrl}${APIConstants.providerLoginVerifyOTP}",
            {
              'Content-Type': 'application/json',
            },
            jsonEncode({
              'mobileNumber': "+91${_phoneController.text}",
              'code': _otpController.text,
            }),
            null,
            false);


        AuthController authController = Get.find();
        authController.activeSession.value = true;
        authController.userRole.value = "PROVIDER";
        String jwtToken = response['token'];
        Storage.saveValue(StorageKeys.USER_ROLE, "PROVIDER");
        Storage.saveValue(StorageKeys.JWT_TOKEN, jwtToken);
        Storage.saveValue(StorageKeys.USER_ID, response["provider"]["_id"]);
        Utils.showSnackbar("Yeah !", response["message"], CustomSnackbarStatus.success);
        Get.offAllNamed(RouteName.provider_home);


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
        _hideLoading();
      }
    } else {
      Utils.showSnackbar("Almost There!", "Please write valid OTP",
          CustomSnackbarStatus.warning);
    }
  }

  @override
  void initState() {

    super.initState();

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
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                // Header Section
        
                Container(
                  key: _containerKeyHero,
                  padding: const EdgeInsets.only(
                      top: AppDimensions.auth_screen_top_padding,
                      left: AppDimensions.auth_screen_padding,
                      right: AppDimensions.auth_screen_padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: robotoNormal.copyWith(
                          color: Colors.white38,
                          fontSize: AppDimensions.largeFontSize
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Login',
                        style: robotoBold.copyWith(
                          color: white,
                          fontSize: AppDimensions.extraLargeFontSize*1.5,
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: 'New User? ',
                          style: robotoNormal.copyWith(
                            color: white,
                            fontSize: AppDimensions.regularFontSize,
                          ),
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: robotoBold.copyWith(
                                color: Colors.blue, // Different color for "Login"
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
                                            const Registration()),
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
                          StepItem(
                            stepNumber: 1,
                            label: 'Phone',
                            currentPhase: currentPhase,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 25.0,
                                right: 20,
                              ),
                              child: currentPhase == 1
                                  ? const DottedLine(
                                      dashColor: Colors.green,
                                      dashLength: 3.0,
                                      dashGapLength: 4.0,
                                      lineThickness: 2.0,
                                    )
                                  : currentPhase == 0
                                      ? const DottedLine(
                                          dashColor: Colors.grey,
                                          dashLength: 3.0,
                                          dashGapLength: 4.0,
                                          lineThickness: 2.0,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                          StepItem(
                            stepNumber: 2,
                            label: 'OTP',
                            currentPhase: currentPhase,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  constraints: BoxConstraints(
                      minHeight: screenHeight - containerHeroHeight - AppDimensions.auth_screen_top_padding - containerNextButtonHeight - 30),
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
                    child: (currentPhase == 0)
                        ? PhonePage(
                            phoneController: _phoneController,
                            formKey: _phoneFormKey,
                          )
                        : OtpPage(
                            phone: _phoneController.text,
                            otpController: _otpController,
                            formKey: _otpFormKey,
                          ),
                  ),
                ),
                // Footer Buttons
                Container(
                  key: _containerKeyNextButton,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  color: white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      if(currentPhase == 1)
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (currentPhase > 0) currentPhase -= 1;
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
                                } else {
                                  _submitOtp();
                                }
                              });
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Icon(Icons.arrow_forward,size: 22,color: Colors.black,weight: 1,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading)
              Utils.getLoadingWidget()
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
