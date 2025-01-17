

import 'package:get/get.dart';
import 'package:raithan_serviceapp/network/BaseApiServices.dart';
import 'package:raithan_serviceapp/network/NetworkApiService.dart';

class AuthController extends GetxController{
   RxString userRole = ''.obs;
   RxBool activeSession = false.obs;

   final BaseApiServices baseApiServices = NetworkApiService();
}