
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/constants/enums/custom_snackbar_status.dart';
import 'package:raithan_serviceapp/network/app_exception.dart';
import '../constants/routes/route_name.dart';
import 'app_colors.dart';

class Utils{

  static changeNodeFocus(
      BuildContext context, FocusNode current, FocusNode target) {
    current.unfocus();
    FocusScope.of(context).requestFocus(target);
  }


  static handleException(Exception exception) {

      if (exception is UnAuthorizedException ) {
        Get.toNamed(RouteName.login);

        showSnackbar('Oops !', 'Not Authorized Please login first', CustomSnackbarStatus.error);
      }
      else
      {
        showSnackbar('Oops !', exception.toString() , CustomSnackbarStatus.error);
      }

  }

  static showSnackbar(
      String title, String message, CustomSnackbarStatus snackbarStatus) {


    if (CustomSnackbarStatus.error == snackbarStatus) {
      Get.snackbar(
        title,
        message,
        colorText: AppColors.whiteColor,
        backgroundColor: AppColors.errorBackground,
        icon: const Icon(
          Icons.add_alert_outlined,
          color: AppColors.whiteColor,
        ),
      );
    } else if (CustomSnackbarStatus.info == snackbarStatus) {
      Get.snackbar(
        title,
        message,
        colorText: AppColors.blackColor,
        backgroundColor: AppColors.infoBackground,
        icon: const Icon(Icons.info_outline, color: AppColors.whiteColor),
      );
    } else if (CustomSnackbarStatus.success == snackbarStatus) {
      Get.snackbar(
        title,
        message,
        colorText: AppColors.whiteColor,
        backgroundColor: AppColors.successBackground,
        icon:
        const Icon(Icons.check_circle_outline, color: AppColors.whiteColor),
      );
    }
    else if (CustomSnackbarStatus.warning == snackbarStatus) {
      Get.snackbar(
        title,
        message,
        colorText: AppColors.whiteColor,
        backgroundColor: AppColors.warningBackground,
        icon:
        const Icon(Icons.warning_outlined, color: AppColors.whiteColor),
      );
    }
  }

}