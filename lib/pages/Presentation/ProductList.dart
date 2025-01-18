import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
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
      appBar: customAppBar(businessType, context, options: false),
      floatingActionButton: Obx(() {
        if (!controller.isLoading.value) {
          return FloatingActionButton(
            onPressed: () {
              if(businessType == BusinessCategory.MECHANICS.name || businessType == BusinessCategory.AGRICULTURE_LABOR.name) {
                Get.toNamed(RouteName.editLaborDetails,
                    arguments: {"businessType": businessType});
              }
              else{
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
          : controller.getProductList()),
    );
  }
}
