import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/constants/enums/image_type.dart';

import '../Utils/utils.dart';

class CustomImageField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String? url;
  bool isUpdated = false;

  CustomImageField({
    Key? key,
    required this.controller,
    required this.title,
    this.url,
  }) : super(key: key);

  @override
  _CustomImageFieldState createState() => _CustomImageFieldState();
}

class _CustomImageFieldState extends State<CustomImageField> {
  String? _filePath;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        widget.controller.text = _filePath!;
        widget.isUpdated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      // Prevents the keyboard from appearing
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black, // Explicit text color set to black
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      validator: (value){
        if(!widget.isUpdated && widget.url == null)
          {
            return "Please Select Image";
          }
      },
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          // Ensures the row takes up minimal space
          children: [
            IconButton(
              icon: const Icon(
                Icons.upload_file,
                color: Colors.grey,
              ),
              onPressed: _pickImage,
            ),
            if (_filePath != null)
              IconButton(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Utils.showImagePopup(context, widget.controller.text,
                      widget.isUpdated ? ImageType.FILE_IMAGE :
                      ImageType.NETWORK_IMAGE);
                },
              ),
          ],
        ),
        hintText: widget.title,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        // Implement your onTap functionality here
      },
    );
  }
}
