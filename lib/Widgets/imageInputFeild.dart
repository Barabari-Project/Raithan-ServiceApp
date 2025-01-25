import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';

class ImagePickerField extends StatefulWidget {
  final TextEditingController? controller; // Make controller optional
  final String? Function(String?)? validator; // Make validator optional

  const ImagePickerField({
    super.key,
    this.controller, // Make controller optional
    this.validator, // Make validator optional
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );


    if (result != null) {
      setState(() {
        _selectedImage = File(result.files.first.path!);
        widget.controller!.text = result.files.first.path!;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller, // Use the local controller
          readOnly: true, // Prevent keyboard from appearing
          cursorColor: Colors.black,
          style: robotoBold.copyWith(
            color: black, // Explicit text color set to black
            fontSize: 16,
          ),
          decoration: InputDecoration(
            label: Text("Upload Image".tr),
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
              onPressed: _pickImage,
            ),
            hintText: "Select an image".tr,
            hintStyle: robotoBold.copyWith(
              color: grey,
              fontSize: 14,
            ),
          ),
          validator: widget.validator, // Use the passed validator (if any)
          onTap: _pickImage,
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
}
