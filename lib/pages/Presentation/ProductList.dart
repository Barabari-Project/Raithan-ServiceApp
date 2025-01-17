import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/controller/product_list_controller.dart';
import 'package:raithan_serviceapp/dtos/agriculture_dto.dart';

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
            onPressed: () {},
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
