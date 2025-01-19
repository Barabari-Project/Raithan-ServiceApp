import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart' hide Response;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/constants/enums/custom_snackbar_status.dart';
import 'package:raithan_serviceapp/constants/enums/image_type.dart';
import 'package:raithan_serviceapp/network/app_exception.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widget_zoom/widget_zoom.dart';

import '../constants/routes/route_name.dart';
import 'app_colors.dart';

class Utils {
  static Future<void> clearImageCache(String url) async {
    await DefaultCacheManager().removeFile(url);
  }

  static CachedNetworkImage getCachedNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fitWidth,
      width: double.infinity,
      errorWidget: (context, url, error) {
        return const Text("Image Not Found");
      },
      placeholder: (context, url) {
        return Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 216, 216, 216),
            highlightColor: const Color.fromARGB(255, 255, 255, 255),
            child: Container(
              color: Colors.amber,
            ));
      },
    );
  }

  static CachedNetworkImage getCachedNetworkImageForProfile(String url,
      {Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder =
          null}) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fitWidth,
      width: double.infinity,
      errorWidget: (context, url, error) {
        return const Text("Image Not Found");
      },
      imageBuilder: imageBuilder,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: CircleAvatar(
          radius: AppDimensions.width * 0.2 - 4, // Same radius as image
          backgroundColor: Colors.grey[300], // Placeholder shimmer color
        ),
      ),
    );
  }

  static changeNodeFocus(
      BuildContext context, FocusNode current, FocusNode target) {
    current.unfocus();
    FocusScope.of(context).requestFocus(target);
  }

  static String convertTo12HourFormat(String time24) {
    if (time24.contains('AM') || time24.contains('PM')) {
      return time24; // No change needed, already in 12-hour format
    }

    List<String> parts =
        time24.split(':'); // Split the time into hours and minutes
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Determine AM/PM
    String period = hours >= 12 ? 'PM' : 'AM';

    // Convert hour to 12-hour format
    int hour12 = hours % 12;
    if (hour12 == 0) hour12 = 12; // Handle 0 as 12 for AM/PM format

    // Format minutes with leading zero if necessary
    String formattedTime =
        '$hour12:${minutes.toString().padLeft(2, '0')} $period';
    return formattedTime;
  }

  static handleException(Exception exception) {
    if (exception is UnAuthorizedException) {
      Get.toNamed(RouteName.login);

      showSnackbar('Oops !', 'Not Authorized Please login first',
          CustomSnackbarStatus.error);
    } else {
      showSnackbar('Oops !', exception.toString(), CustomSnackbarStatus.error);
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
    } else if (CustomSnackbarStatus.warning == snackbarStatus) {
      Get.snackbar(
        title,
        message,
        colorText: AppColors.blackColor,
        backgroundColor: AppColors.warningBackground,
        icon: const Icon(Icons.warning_outlined, color: AppColors.blackColor),
      );
    }
  }

  static Widget getLoadingWidget([double height = 30]) {
    return Container(
      // color: Colors.black.withOpacity(0.5),
      height: AppDimensions.height,
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: Colors.green,
          size: height,
        ),
      ),
    );
  }

  static Color getBackgroundColorByIndex(int index) {
    List<Color> colors = [
      Colors.purple.shade200.withValues(alpha: 0.2),
      Colors.orange.shade200.withValues(alpha: 0.2),
      Colors.green.shade200.withValues(alpha: 0.2),
      Colors.blue.shade200.withValues(alpha: 0.2),
      Colors.red.shade200.withValues(alpha: 0.2),
    ];

    return colors[index % colors.length];
  }

  static Color getColorByIndex(int index) {
    List<Color> colors = [
      Colors.purple.shade800,
      Colors.orange.shade800,
      Colors.green.shade800,
      Colors.blue.shade800,
      Colors.red.shade800,
    ];

    return colors[index % colors.length];
  }

  static String getFileType(String filePath) {
    return filePath.split(".").last;
  }

  static String addCacheBustingParameter(String url) {
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}timestamp=${DateTime.now().millisecondsSinceEpoch}';
  }

  static void showImagePopup(BuildContext context, url, ImageType imageType) {
    dynamic image;
    if (imageType == ImageType.ASSET_IMAGE) {
      image = Image.asset(
        url,
        fit: BoxFit.contain,
        width: double.infinity,
      );
    } else if (imageType == ImageType.FILE_IMAGE) {
      image = Image.file(
        File(url),
        fit: BoxFit.contain,
        width: double.infinity,
      );
    } else {
      image = getCachedNetworkImage(url);
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        // Prevents dismissal by tapping outside the dialog
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            children: [
              Stack(alignment: Alignment.center, children: [
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: AppDimensions.height * 0.7,
                    width: AppDimensions.width * 0.8,
                    child: WidgetZoom(
                      heroAnimationTag: 'tag',
                      zoomWidget: image,
                    )),
                Positioned(
                  top: -5, // Adjust as needed
                  right: -10, // Adjust as needed
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ])
            ],
          );
        });
  }

  static void showBackDropLoading(BuildContext context)
  {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (context) {
        return Material(
          color: Colors.transparent, // Ensure the backdrop is transparent
          child: Stack(
            children: [
              ModalBarrier(
                dismissible: false, // Prevent dismissal
                color: Colors.black.withValues(alpha: 0.3), // Transparent background
              ),
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3), // Semi-transparent loader box
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: LoadingAnimationWidget.hexagonDots(
                    color: Colors.white,
                    size: 30,),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
