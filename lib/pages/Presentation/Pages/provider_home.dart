import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/custom_appbar.dart';
import '../../../controller/profile_controller.dart';

class ProviderHome extends GetView<ProfileController> {
  ProviderHome({super.key}) {
    Get.lazyPut(() => ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Raithan", context),
      body: SingleChildScrollView(
        child: Row(
          children: [Container(child: Text("Provider Home Page"))],
        ),
      ),
    );
  }
}
