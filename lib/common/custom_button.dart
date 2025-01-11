import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isPrimary;
  final double width;
  final bool isLoading;
  final Color backgroundColor;

  const CustomButton(
      {this.onPressed,
        required this.child,
        required this.isPrimary,
        this.width = double.infinity,
        this.isLoading = false,
        this.backgroundColor = AppColors.appBackgroundColor,
        super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        width: width,
        child: isPrimary
            ? FilledButton(
            onPressed: isLoading ? () {} : onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(18, 130, 105,1)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            child: isLoading
                ?   Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Utils.getLoadingWidget(25),
              ),
            )
                : child)
            : OutlinedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            child: isLoading
                ?  const Center(
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
              ),
            )
                : child));
  }
}
