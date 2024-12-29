import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        widget.controller!.text = pickedFile.path;
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
          controller: widget.controller, // Use the local controller
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
          validator: widget.validator, // Use the passed validator (if any)
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
}
