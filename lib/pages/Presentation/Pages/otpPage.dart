import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/constants/regex_constant.dart';

import '../../../constants/api_constants.dart';
import '../../Data/Repository/onboarding_repository.dart';

class OtpPage extends StatefulWidget {
  final TextEditingController otpController;
  final GlobalKey<FormState> formKey;
  final String phone;
  final void Function(BuildContext context) sentOtp;
  const OtpPage(
      {super.key,
      required this.otpController,
      required this.formKey,
      required this.sentOtp,
      required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late Timer _timer;
  int _remainingSeconds = 30; // Countdown timer in seconds
  bool timerRunning = true;

  final OnboardingRepository _onboardingRepository = OnboardingRepository(
    baseUrl: APIConstants.baseUrl,
  );
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _remainingSeconds = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          timerRunning = false;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel(); // Avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double boxWidth = (constraints.maxWidth - 50) / 6;

        return Padding(
          padding: EdgeInsets.all(AppDimensions.formFieldPadding),
          child: Form(
            key: widget.formKey, // Use the passed form key here
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OTP sent successfully to".tr,
                    style: robotoNormal.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "+91 ${widget.phone}",
                        style: robotoBold.copyWith(
                          color: black,
                          fontSize: 24,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          formatTime(_remainingSeconds),
                          style: robotoNormal.copyWith(
                            color: black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    controller: widget.otpController,
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: boxWidth,
                      height: boxWidth,
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: boxWidth,
                      height: boxWidth,
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP'.tr;
                      }
                      if (value.length != 6 ||  !RegExp(RegexConstant.otpOrPincodeValidationRegex).hasMatch(value)) {
                        return 'OTP must be 6 digits'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (!timerRunning) {
                            // make an api call
                            widget.sentOtp(context);
                            startTimer();
                            setState(() {
                              timerRunning = true;
                            });
                          }
                        },
                        child: Text(
                          "Resend OTP".tr,
                          style: robotoBold.copyWith(
                            color: timerRunning ? Colors.black38 : black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
