import 'dart:convert';
import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:raithan_serviceapp/Onboarding/Data/Repository/onboarding_repository.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/businessDetailsPage.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/otpPage.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/personalDetailsPage.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/phonePage.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/login.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/constants/api_constants.dart';
import 'package:raithan_serviceapp/constants/enums/custom_snackbar_status.dart';
import 'package:raithan_serviceapp/home.dart';

import '../../dtos/file_with_media_type.dart';
import '../../network/BaseApiServices.dart';
import '../../network/NetworkApiService.dart';
import 'package:http_parser/http_parser.dart';


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
  final TextEditingController _categoryController = TextEditingController();

// Define controllers for the working days (use a map or individual controllers)
  final Map<String, bool> _workingDays = {
    'Monday': true,
    'Tuesday': false,
    'Wednesday': true,
    'Thursday': false,
    'Friday': true,
    'Saturday': true,
    'Sunday': false,
  };

// Define the working time controllers (start and end time)
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _detailFormKey = GlobalKey<FormState>();
  BaseApiServices baseApiServices = NetworkApiService();

  final OnboardingRepository _onboardingRepository = OnboardingRepository(
    baseUrl: APIConstants.baseUrl,
  );

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
    if (_phoneFormKey.currentState?.validate() ?? false) {
      _showLoading(); // Show loading indicator

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

        setState(() {
          currentPhase = 1;
        });

        Utils.showSnackbar(
            "Yeah !", response["message"], CustomSnackbarStatus.success);

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
        _hideLoading(); // Hide loading indicator
      }

    } else {
      _hideLoading(); // Hide loading indicator
    }
  }

  void _submitOtp() async {
    if (_otpFormKey.currentState?.validate() ?? false) {
      _showLoading();
      try {
        final response = await baseApiServices.getPostApiResponse("${APIConstants.baseUrl}${APIConstants.providerVerifyOTP}",
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
        Storage.saveValue("jwtToken", jwtToken);
        Utils.showSnackbar("Yeah !", response["message"], CustomSnackbarStatus.success);

        setState(() {
          currentPhase = 2;
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
      _hideLoading(); // Hide loading indicator

      // InVoke Validator every where
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
    }
  }

  void _submitDetails() async {
    if (_detailFormKey.currentState?.validate() ?? false) {
      _showLoading();
      try {

        String filePath = _imageController.text;

        List<String> filePart = filePath.split(".");

        MediaType imageMediaType = MediaType('image', filePart.last); // Assuming the file is a JPEG image

        final response = await baseApiServices.postMultipartFilesUploadApiResponse(APIConstants.providerSaveProfileDetails,
            null, {
              'firstName': _firstNameController.text,
              'lastName': _lastNameController.text,
              'yearOfBirth': _dobController.text,
              'gender': _genderController.text,
            }, {'img': FileWithMediaType(File(filePath), imageMediaType) }, true);

        Utils.showSnackbar("Yeah !", response?["message"], CustomSnackbarStatus.success);

        setState(() {
          currentPhase = 3;
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
      _hideLoading();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid Personal Details')),
      );
    }
  }

  void _submitBusinessDetails() async {
    if (_detailFormKey.currentState?.validate() ?? false) {
      _showLoading();
      try {

        await _onboardingRepository.uploadProfile(
          image: File(_imageController.text),
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          year: _dobController.text,
          gender: _genderController.text,
        );

        setState(() {
          currentPhase = 3;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Something went wrong. Please Try Again.")),
        );
      } finally {
        _hideLoading();
      }
    } else {
      _hideLoading();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid Personal Details')),
      );
    }
  }

  @override
  void initState() {
    if (widget.phone != null) {
      setState(() {
        _phoneController.text = widget.phone!;
      });
    }
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final RenderBox renderBoxHero = _containerKeyHero.currentContext?.findRenderObject() as RenderBox;
      final RenderBox renderBoxNextButton = _containerKeyNextButton.currentContext?.findRenderObject() as RenderBox;

      setState(() {
        containerHeroHeight = renderBoxHero.size.height;
        containerNextButtonHeight = renderBoxNextButton.size.height;
      });
    });
  }

  Widget getLineProgressWidget(int currentPhase, int stepNumber)
  {
    if (stepNumber == currentPhase) {
      return const DottedLine(dashColor: Colors.green,
        dashLength: 3.0,
        dashGapLength: 4.0,
        lineThickness: 2.0,);
    } else if (stepNumber > currentPhase) {
      return const DottedLine(dashColor: Colors.grey,
        dashLength: 3.0,
        dashGapLength: 4.0,
        lineThickness: 2.0,);
    } else {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.green,),),);
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
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            dobController: _dobController,
            imageController: _imageController,
            genderController: _genderController,
            formKey: _detailFormKey,
          );

    }


    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                // Header Section
                if (!(isKeyboardVisible && currentPhase == 2))
                  Container(
                    key: _containerKeyHero,
                    // height: 250,
                    padding: const EdgeInsets.only(top: AppDimensions.auth_screen_top_padding, left: AppDimensions.auth_screen_padding, right: AppDimensions.auth_screen_padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: robotoNormal.copyWith(
                            color: Colors.white38,
                            fontSize: AppDimensions.regularFontSize
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Register',
                          style: robotoBold.copyWith(
                            color: white,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: 'Already Registered? ',
                            style: robotoNormal.copyWith(
                              color: white,
                              fontSize: 10,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: robotoBold.copyWith(
                                  color:
                                      Colors.blue, // Different color for "Login"
                                  fontSize: 10,
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            StepItemText(
                              stepNumber: 1,
                              label: 'Phone  ',
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            StepItemText(
                              stepNumber: 2,
                              label: ' OTP  ',
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            StepItemText(
                              stepNumber: 3,
                              label: '   Profile',
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            StepItemText(
                              stepNumber: 4,
                              label: 'Business',
                            ),
                          ],
                        ),
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
                                  right: 5,
                                  top: 3
                                ),
                                child: getLineProgressWidget(currentPhase, 0)
                              ),
                            ),
                            StepItem(
                              stepNumber: 2,
                              label: 'OTP',
                              currentPhase: currentPhase,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 5,
                                  top: 3
                                ),
                                child: getLineProgressWidget(currentPhase, 1)
                              ),
                            ),
                            StepItem(
                              stepNumber: 3,
                              label: 'Details',
                              currentPhase: currentPhase,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 5,
                                  top: 3
                                ),
                                child: getLineProgressWidget(currentPhase, 2)
                              ),
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
                const SizedBox(height: 30),
                // Dynamic Content Section

                Container(
                  // height: screenHeight - containerHeroHeight - 30 - containerNextButtonHeight - AppDimensions.auth_screen_top_padding,
                  constraints: BoxConstraints(
                    minHeight:  screenHeight - containerHeroHeight - containerNextButtonHeight - AppDimensions.auth_screen_top_padding
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(92, 248, 244, 244),
                    borderRadius:  BorderRadius.only(
                      topLeft: Radius.circular(37),
                      topRight: Radius.circular(37),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F4F4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                          left: 10,
                          right: 10,
                        ),
                        child: currentPage
                      ),
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
                          margin: const EdgeInsets.only(left: 10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              TextButton(
                                onPressed: (){
                                  setState(() {
                                    if (currentPhase == 0) {
                                      _submitPhone(context);
                                    } else if (currentPhase == 1) {
                                      _submitOtp();
                                    } else if( currentPhase == 2){
                                      _submitDetails();
                                    }
                                    else{
                                      _submitBusinessDetails();
                                    }
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      ' Next',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),

                                    ),
                                    IconButton(
                                      iconSize: 22.0,
                                      padding: EdgeInsets.only(bottom: 1),
                                      icon: const Icon(Icons.arrow_forward),
                                      color: Colors.black, onPressed: () {
                                      setState(() {
                                        if (currentPhase == 0) {
                                          _submitPhone(context);
                                        } else if (currentPhase == 1) {
                                          _submitOtp();
                                        } else if( currentPhase == 2){
                                          _submitDetails();
                                        }
                                        else{
                                          _submitBusinessDetails();
                                        }
                                      });
                                    },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                height: screenHeight,
                child: Center(
                  child: LoadingAnimationWidget.beat(
                    color: Colors.green,
                    size: 30,
                  ),
                ),
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
        Column(
          children: [

                SizedBox(width: 30,)

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
