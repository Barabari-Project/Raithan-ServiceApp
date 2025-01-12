import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_colors.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/common/custom_appbar.dart';
import 'package:raithan_serviceapp/common/custom_button.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/controller/business_controller.dart';

class Business extends GetView<BusinessController> {
  Business({super.key}) {
    Get.lazyPut(() => BusinessController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Business", context, options: false),
      body: Obx(
        () => SingleChildScrollView(
          child: Container(
              // controller: controller.scrollController,
              child: controller.isLoading.value
                  ? Utils.getLoadingWidget()
                  : Column(children: [
                      SizedBox(
                        height: AppDimensions.formFieldPadding * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.all(AppDimensions.formFieldPadding),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: AppDimensions.formFieldPadding * 0.5,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Business Information",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              BusinessInfoTile(
                                label: 'Business Name',
                                value: controller.businessDetails['Business Name'],
                                isFirst: true,
                                isLast: true,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppDimensions.formFieldPadding,vertical: 0),
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.grey)),
                                ),
                              ),
                              SizedBox(height: AppDimensions.formFieldPadding*0.5,),
                              const Text(
                                "Categories",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: AppDimensions.formFieldPadding*0.25,),
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: AppDimensions.formFieldPadding),
                                child: Wrap(
                                  spacing: AppDimensions.formFieldPadding ,
                                  // Horizontal spacing between children
                                  runSpacing:
                                  AppDimensions.formFieldPadding * 0.5,
                                  // Vertical spacing between lines
                                  alignment: WrapAlignment.center,
                                  children: controller.categories
                                      .map((day) => Text(
                                        day,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ))
                                      .toList(),
                                ),
                              ),
                              SizedBox(height: AppDimensions.formFieldPadding*0.5,)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0,
                            left: AppDimensions.formFieldPadding,
                            right: AppDimensions.formFieldPadding,
                            bottom: AppDimensions.formFieldPadding),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: AppDimensions.formFieldPadding * 0.5,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Business Address",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.businessAddress.length,
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            AppDimensions.formFieldPadding,
                                        vertical: 0),
                                    child: Divider(),
                                  );
                                },
                                itemBuilder: (context, index) {
                                  String label = controller.businessAddress.keys
                                      .elementAt(index);
                                  String value =
                                      controller.businessAddress[label]!;
                                  return BusinessInfoTile(
                                    label: label,
                                    value: value,
                                    isFirst: index == 0,
                                    isLast: index ==
                                        (controller.businessAddress.length - 1),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: AppDimensions.formFieldPadding,
                            right: AppDimensions.formFieldPadding,
                            top: 0,
                            bottom: AppDimensions.formFieldPadding),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: AppDimensions.formFieldPadding * 0.5,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Working Time",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.businessTime.length,
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            AppDimensions.formFieldPadding,
                                        vertical: 0),
                                    child: Divider(),
                                  );
                                },
                                itemBuilder: (context, index) {
                                  String label = controller.businessTime.keys
                                      .elementAt(index);
                                  String value =
                                      controller.businessTime[label]!;
                                  return BusinessInfoTile(
                                    label: label,
                                    value: value,
                                    isFirst: index == 0,
                                    isLast: index ==
                                        (controller.businessTime.length - 1),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: AppDimensions.formFieldPadding,
                            right: AppDimensions.formFieldPadding,
                            top: 0,
                            bottom: AppDimensions.formFieldPadding),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: AppDimensions.formFieldPadding * 0.5,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Working Days",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: AppDimensions.formFieldPadding * 0.5,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppDimensions.formFieldPadding),
                                child: Wrap(
                                  spacing: AppDimensions.formFieldPadding ,
                                  // Horizontal spacing between children
                                  runSpacing:
                                      AppDimensions.formFieldPadding * 0.5,
                                  // Vertical spacing between lines
                                  alignment: WrapAlignment.center,
                                  children: controller.businessDays
                                      .map((day) => Text(
                                        day,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ))
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.formFieldPadding * 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomButton(
                          isPrimary: true,
                          width: 100,
                          onPressed: ()
                          {
                            Get.toNamed(RouteName.businessEdit,arguments: controller.businessInfo);
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.whiteColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Edit",
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                            ],
                          )),
                SizedBox(
                  height: AppDimensions.formFieldPadding ,
                ),
                    ])),
        ),
      ),
    );
  }
}

class BusinessInfoTile extends StatelessWidget {
  final String label;
  final bool isFirst;
  final bool isLast;
  final String value;

  BusinessInfoTile(
      {required this.label,
      required this.value,
      required this.isFirst,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: AppDimensions.formFieldPadding,
          right: AppDimensions.formFieldPadding,
          top: isFirst ? AppDimensions.formFieldPadding * 0.5 : 0.0,
          bottom: isLast ? AppDimensions.formFieldPadding * 0.5 : 0.0),
      // padding: EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
              child: Text(
            value, textAlign: TextAlign.right,
            maxLines: 4,
            // Limits the text to 2 lines
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
    );
  }
}
