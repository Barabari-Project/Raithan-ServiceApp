import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';

class DropdownTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final List<String> options;
  final String? Function(String?)? validator;

  const DropdownTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.options,
    this.validator,
  });

  @override
  State<DropdownTextField> createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

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

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
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
                          widget.controller.text = option;
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
        controller: widget.controller,
        readOnly: true, // Prevent manual text editing
        decoration: InputDecoration(
          labelText: widget.label,
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
          suffixIcon: const Icon(Icons.arrow_drop_down, color: grey),
        ),
        validator: widget.validator,
        onTap: () {
          if (_overlayEntry == null) {
            _showDropdown();
          } else {
            _hideDropdown();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }
}
