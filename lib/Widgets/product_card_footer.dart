import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ProductCardFooter extends StatelessWidget {
  final dynamic productDetails; // Replace `dynamic` with your specific model type
  final String businessType;
  final RxString userRole;
  final VoidCallback onCallNow;
  final VoidCallback onEdit;
  final VoidCallback rateUs;

  const ProductCardFooter({
    Key? key,
    required this.productDetails,
    required this.businessType,
    required this.userRole,
    required this.onCallNow,
    required this.onEdit,
    required this.rateUs
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx( () => RatingBarIndicator(
            rating: productDetails.avgRating.value,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
        ),
        const SizedBox(width: 5.0),
        Obx(() => Text('${productDetails.avgRating.value.toStringAsFixed(1)}')),
        const Expanded(child: SizedBox()),
        if(userRole.value == "SEEKER")
        OutlinedButton(onPressed: rateUs,
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Rate Us".tr),
                const SizedBox(width: 4),
                const Icon(Icons.star_border_rounded),
              ],
            ),
        ),
        if(userRole.value == "SEEKER")
        const SizedBox(width: 10.0),
        OutlinedButton(
          onPressed: () {
            if (userRole.value == "PROVIDER") {
              onEdit();
            } else {
              onCallNow();
            }
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(userRole.value == "PROVIDER" ? "Edit".tr : "Call Now".tr),
              const SizedBox(width: 4),
              Icon(userRole.value == "PROVIDER" ? Icons.edit : Icons.call),
            ],
          ),
        ),
      ],
    );
  }
}
