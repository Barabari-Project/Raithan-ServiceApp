
import 'package:flutter/material.dart';

class Utils{
  static changeNodeFocus(
      BuildContext context, FocusNode current, FocusNode target) {
    current.unfocus();
    FocusScope.of(context).requestFocus(target);
  }
}