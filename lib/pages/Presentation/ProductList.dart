import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/Widgets/filter_dropdown.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/controller/product_list_controller.dart';

import '../../common/custom_appbar.dart';

class ProductList extends GetView<ProductListController> {

  late String businessType;

  ProductList({super.key}) {
    dynamic args = Get.arguments;
    businessType = args['category'];
    Get.lazyPut(() => ProductListController(businessType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(businessType.tr, context, options: false),
      floatingActionButton: Obx(() {
        if (!controller.isLoading.value && controller.authController.userRole.value == "PROVIDER") {
          return FloatingActionButton(
            onPressed: () {
              if (businessType == BusinessCategory.MECHANICS.name || businessType == BusinessCategory.AGRICULTURE_LABOR.name) {
                Get.toNamed(RouteName.editLaborDetails, arguments: {"businessType": businessType});
              } else {
                Get.toNamed(RouteName.editProductDetails, arguments: {"businessType": businessType});
              }
            },
            backgroundColor: const Color.fromRGBO(18, 130, 105, 1),
            mini: true,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
      body: Obx(() => controller.isLoading.value
          ? Utils.getLoadingWidget()
          : Column(
              children: [
                if(controller.authController.userRole.value != "PROVIDER")
                Padding(
                  padding:
                      EdgeInsets.all(AppDimensions.formFieldPadding * 0.75),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Radius Dropdown
                      SizedBox(
                        width : AppDimensions.width*0.45,
                        child: FilterDropDown(
                          controller: controller.distanceController,
                          label: "Distance".tr,
                          focusNode: FocusNode(),
                          onChanged: (value) {
                              controller.fetchAndSetProductDetails();
                          },
                          options: ['5 Km', '10 Km', '15 Km'],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      if(controller.isHorsePowerFilterApplicable)
                      Expanded(child: SizedBox()), // Spacing between the dropdowns
                      // HP Dropdown
                      if(controller.isHorsePowerFilterApplicable)
                      SizedBox(
                        width : AppDimensions.width*0.45,
                        child: FilterDropDown(
                          controller: controller.horsePowerController,
                          label: "Horse Power".tr,
                          focusNode: FocusNode(),
                          onChanged: (value) {
                             controller.fetchAndSetProductDetails();
                          },
                          options: ['25 Hp', '30 Hp', '35 Hp'],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // FilterScreen(),
                controller.noProducts.value
                    ? Expanded(
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/no_product.png',
                                  width: AppDimensions.width*0.6,
                                ),
                                Text("No Products".tr, style: const TextStyle(fontSize: AppDimensions.largeFontSize*1.5),)
                              ]),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child:
                            Column(children: [...controller.getProductList()]),
                      ))
              ],
            )),
    );
  }
}
