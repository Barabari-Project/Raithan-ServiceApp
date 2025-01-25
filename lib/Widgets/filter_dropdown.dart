import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';

class FilterDropDown extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final List<String> options;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  void Function(String)? onFieldSubmitted;
  bool makeBigLabelSize = false;

  FilterDropDown(
      {super.key,
      required this.controller,
      required this.label,
      required this.options,
      this.validator,
      this.onChanged,
      this.focusNode,
      this.onFieldSubmitted});

  @override
  State<FilterDropDown> createState() => _FilterDropDown();
}

class _FilterDropDown extends State<FilterDropDown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.controller.text != "")
      {
        widget.makeBigLabelSize = true;
      }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    double dropdownTop = offset.dy + size.height + 5;

    // Check if the dropdown would overflow the screen and adjust the position
    if (dropdownTop + 200 > AppDimensions.height) {
      dropdownTop = offset.dy - 5 - 200; // Show above the field if below screen
    }

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: dropdownTop,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.options
                  .map(
                    (option) => ListTile(
                      title: Text(option),
                      onTap: () {
                        setState(() {
                          widget.controller.value =
                              TextEditingValue(text: option);
                          widget.onChanged!(option);
                        });
                        _hideDropdown();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        onChanged: widget.onChanged,
        controller: widget.controller,
        focusNode: widget.focusNode,
        readOnly: true, // Prevent manual text editing
        decoration: InputDecoration(
          isDense: true, // Compact design
          // labelText: widget.label,
          label: Text(widget.label,style: TextStyle(fontSize: widget.makeBigLabelSize ? 18 : 15),),
          labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey[600]),
          filled: true, // Enable background color
          fillColor: Colors.grey[200], // Light background color
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green), // Remove border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjust padding
        ),
        validator: widget.validator,
        onTap: () {
          if (_overlayEntry == null) {
            setState(() { widget.makeBigLabelSize = true; });
            _showDropdown();
          } else {
            _hideDropdown();
          }
        },
        style: TextStyle(
          fontSize: 16, // Adjust font size
          color: Colors.black, // Text color
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }
}
