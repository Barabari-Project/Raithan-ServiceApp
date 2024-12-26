import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Registration(),
  ));
}

class Registration extends StatefulWidget {
  Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  int currentPhase = 0;

  final phoneController = TextEditingController();
  late Timer _timer;
  int _remainingSeconds = 10; // 2 minutes in seconds
  bool timerRunning = false;
  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    _remainingSeconds = 10;
    setState(() {
      timerRunning = true;
    });

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
    _timer.cancel(); // Always cancel timers in dispose to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Column(
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
                  'Register',
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 30.0,
                          right: 20,
                        ),
                        child: currentPhase == 2
                            ? const DottedLine(
                                dashColor: Colors.green,
                                dashLength: 3.0,
                                dashGapLength: 4.0,
                                lineThickness: 2.0,
                              )
                            : currentPhase == 1 || currentPhase == 0
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
                      stepNumber: 3,
                      label: 'Details',
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
                        ? firstPhase(phoneController, context)
                        : (currentPhase == 1)
                            ? secondPhase(phoneController, context)
                            : thirdPahse(context),
                  ),
                ),
              ),
            ),
          ),
          // Footer Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                          if (currentPhase < 3) currentPhase += 1;
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
    );
  }

  Widget firstPhase(controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone",
          style: robotoBold.copyWith(
            color: black,
            fontSize: 26,
          ),
        ),
        Text(
          "You will get 6 digit OTP on your phone",
          style: robotoBold.copyWith(
            color: Colors.black45,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        textField(controller, TextInputType.phone, "Phone"),
      ],
    );
  }

  Widget secondPhase(controller, BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Calculate the width dynamically
      double boxWidth =
          (constraints.maxWidth - 50) / 6; // 40 for padding/margins

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "OTP sent successfully to",
              style: robotoNormal.copyWith(
                fontSize: 14,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+91 8141350732",
                  style: robotoBold.copyWith(
                    color: black,
                    fontSize: 24,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
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
            const SizedBox(
              height: 20,
            ),
            Pinput(
              length: 6,
              defaultPinTheme: PinTheme(
                width: boxWidth, // Dynamic width
                height: boxWidth, // Match height to width for square boxes
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: boxWidth,
                height: boxWidth,
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onCompleted: (pin) => print('Entered PIN: $pin'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (!timerRunning) {
                      startTimer();
                    }
                  },
                  child: Text(
                    "Resend OTP",
                    style: robotoBold.copyWith(
                      color: timerRunning ? Colors.black38 : black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget textField(
      TextEditingController? controller, TextInputType type, String text) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      cursorColor: black,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: black),
      decoration: InputDecoration(
        label: Text(text),
        labelStyle:
            Theme.of(context).textTheme.titleSmall!.copyWith(color: grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grey),
        ),
      ),
    );
  }

  Widget thirdPahse(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal Details",
            style: robotoBold.copyWith(
              color: black,
              fontSize: 20,
            ),
          ),
          sizedBox(),
          textField(null, TextInputType.name, "First Name"),
          sizedBox(),
          textField(null, TextInputType.name, "Last Name"),
          sizedBox(),
          DOBInputField(),
          sizedBox(),
          ImagePickerField(),
        ],
      ),
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      height: 20,
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

class DOBInputField extends StatefulWidget {
  @override
  State<DOBInputField> createState() => _DOBInputFieldState();
}

class _DOBInputFieldState extends State<DOBInputField> {
  final TextEditingController _dobController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dobController,
      readOnly: true, // Prevent keyboard from appearing
      cursorColor: Colors.black,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Colors.black),
      decoration: InputDecoration(
        label: const Text("Date of Birth"),
        labelStyle:
            Theme.of(context).textTheme.titleSmall!.copyWith(color: grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderGrey,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderDarkGrey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderGrey,
        ),
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: grey,
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }
}

class ImagePickerField extends StatefulWidget {
  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final TextEditingController _imageController = TextEditingController();
  File? _selectedImage; // To store the selected image

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageController.text = 'Image Selected';
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _imageController,
          readOnly: true, // Prevent keyboard from appearing
          cursorColor: Colors.black,
          style: robotoBold.copyWith(
            color: black, // Explicit text color set to black
            fontSize: 16,
          ),
          decoration: InputDecoration(
            label: const Text("Upload Image"),
            labelStyle: robotoBold.copyWith(
              color: grey,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: borderGrey,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: borderDarkGrey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: borderGrey,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.upload_file,
                color: grey,
              ),
              onPressed: _showImageSourceDialog,
            ),
            hintText: "Select an image",
            hintStyle: robotoBold.copyWith(
              color: grey,
              fontSize: 14,
            ),
          ),
          onTap: _showImageSourceDialog,
        ),
        const SizedBox(height: 10),
        if (_selectedImage != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _selectedImage!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }
}
