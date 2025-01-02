import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:raithan_serviceapp/Onboarding/Data/Repository/onboarding_repository.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/otpPage.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/phonePage.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int currentPhase = 0;
  bool isLoading = false;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  final OnboardingRepository _onboardingRepository = OnboardingRepository(
    baseUrl: 'https://backend.barabaricollective.org',
  );

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

  void _submitPhone() async {
    if (_phoneFormKey.currentState?.validate() ?? false) {
      _showLoading();
      try {
        final response = await _onboardingRepository.registerMobileNumber(
          _phoneController.text,
          "/raithan/api/service-providers/login",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success: ${response['message']}')),
        );

        setState(() {
          currentPhase = 1;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Something went wrong. Please Try Again.")),
        );
      } finally {
        _hideLoading();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid Phone number')),
      );
    }
  }

  void _submitOtp() async {
    if (_otpFormKey.currentState?.validate() ?? false) {
      _showLoading();
      try {
        final response = await _onboardingRepository.verifyOtp(
          _phoneController.text,
          _otpController.text,
          "/raithan/api/service-providers/login/verify-otp",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success: ${response['message']}')),
        );

        setState(() {
          currentPhase = 2;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Something went wrong. Please Try Again.")),
        );
      } finally {
        _hideLoading();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          Column(
            children: [
              // Header Section

              Container(
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: robotoNormal.copyWith(
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Login',
                      style: robotoBold.copyWith(
                        color: white,
                        fontSize: 36,
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
                              top: 30.0,
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
              // Dynamic Content Section

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(92, 248, 244, 244),
                    borderRadius: BorderRadius.only(
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
                  ),
                ),
              ),
              // Footer Buttons
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
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
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (currentPhase == 0) {
                                _submitPhone();
                              } else {
                                _submitOtp();
                              }
                            });
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: LoadingAnimationWidget.beat(
                  color: Colors.green,
                  size: 30,
                ),
              ),
            ),
        ],
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
              "0${stepNumber.toString()}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
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
