import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';

class MultipleOptionInputField extends StatefulWidget {
  final String title;
  final Map<String, bool> categories;
  final FocusNode? focusNode;

  const MultipleOptionInputField({
    Key? key,
    required this.title,
    required this.categories,
    this.focusNode
  }) : super(key: key);

  @override
  _MultipleOptionInputField createState() => _MultipleOptionInputField();
}

class _MultipleOptionInputField extends State<MultipleOptionInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (isExpanding) {
            if (isExpanding) {
              if(widget.focusNode != null)
                {
                  FocusScope.of(context).requestFocus(widget.focusNode);
                }
            }
          },
          tilePadding: EdgeInsets.zero, // Removes padding around the tile
          collapsedBackgroundColor: Colors.transparent,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: AppDimensions.regularFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: widget.categories.keys.map((category) {
            return CheckboxListTile(
              title: Text(category),
              value: widget.categories[category],
              onChanged: (bool? value) {
                setState(() {
                  widget.categories[category] = value!;
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
