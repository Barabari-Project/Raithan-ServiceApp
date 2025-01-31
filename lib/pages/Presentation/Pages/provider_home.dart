import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';

import '../../../common/custom_appbar.dart';
import '../../../controller/profile_controller.dart';

class ProviderHome extends GetView<ProfileController> {
  ProviderHome({super.key}) {
    Get.lazyPut(() => ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Raithan".tr, context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.formFieldPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Business Categories".tr,
                    style: const TextStyle(
                      fontSize: AppDimensions.largeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: AppDimensions.width * 0.05,
              ),
              Row(
                children: [
                  CategoryWidget(
                      imageUrl: "assets/images/category/drones.png",
                      text: BusinessCategory.DRONES.name,
                      width: AppDimensions.width * 0.425),
                  SizedBox(
                    width: AppDimensions.width * 0.05,
                  ),
                  CategoryWidget(
                      imageUrl: "assets/images/category/agriculture.png",
                      text: BusinessCategory.AGRICULTURE_LABOR.name,
                      width: AppDimensions.width * 0.425),
                ],
              ),
              SizedBox(
                height: AppDimensions.width * 0.05,
              ),
              Row(
                children: [
                  CategoryWidget(
                      imageUrl: "assets/images/category/earth_movers.png",
                      text: BusinessCategory.EARTH_MOVERS.name,
                      width: AppDimensions.width * 0.425),
                  SizedBox(
                    width: AppDimensions.width * 0.05,
                  ),
                  CategoryWidget(
                      imageUrl: "assets/images/category/harverstors.png",
                      text: BusinessCategory.HARVESTORS.name,
                      width: AppDimensions.width * 0.425),
                ],
              ),
              SizedBox(
                height: AppDimensions.width * 0.05,
              ),
              Row(
                children: [
                  CategoryWidget(
                      imageUrl: "assets/images/category/implements.jpg",
                      text: BusinessCategory.IMPLEMENTS.name,
                      width: AppDimensions.width * 0.425),
                  SizedBox(
                    width: AppDimensions.width * 0.05,
                  ),
                  CategoryWidget(
                      imageUrl: "assets/images/category/mechanics.png",
                      text: BusinessCategory.MECHANICS.name,
                      width: AppDimensions.width * 0.425),
                ],
              ),
              SizedBox(
                height: AppDimensions.width * 0.05,
              ),
              Row(
                children: [
                  CategoryWidget(
                      imageUrl:
                          "assets/images/category/paddy_transplantors.jpeg",
                      text: BusinessCategory.PADDY_TRANSPLANTORS.name,
                      width: AppDimensions.width * 0.425),
                  SizedBox(
                    width: AppDimensions.width * 0.05,
                  ),
                  CategoryWidget(
                      imageUrl: "assets/images/category/tractor.png",
                      text: BusinessCategory.MACHINES.name,
                      width: AppDimensions.width * 0.425),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String imageUrl;
  final String text;
  final double width;

  const CategoryWidget({
    required this.imageUrl,
    required this.text,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        child: Material(
          borderRadius:BorderRadius.all(Radius.circular(15)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            onTap: () {
                Get.toNamed(RouteName.products,arguments: {'category':text});
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.95,
                  height: width * 0.65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    // Match the container's border radius
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  text.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
