import 'package:get/get.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/pages/Presentation/Pages/business.dart';
import 'package:raithan_serviceapp/pages/Presentation/Pages/business_edit.dart';
import 'package:raithan_serviceapp/pages/Presentation/ProductList.dart';
import 'package:raithan_serviceapp/pages/splash_screen.dart';

import '../../pages/Presentation/Pages/profile.dart';
import '../../pages/Presentation/Pages/provider_home.dart';
import '../../pages/Presentation/login.dart';
import '../../pages/Presentation/registration.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(name: RouteName.splashScreen, page: () => SplashScreen()),
        GetPage(name: RouteName.profile, page: () => Profile()),
        GetPage(name: RouteName.provider_home, page: () => ProviderHome()),
        GetPage(name: RouteName.login, page: () => LoginScreen()),
        GetPage(name: RouteName.registration, page: () => Registration()),
        GetPage(name: RouteName.business, page: () => Business()),
        GetPage(name: RouteName.businessEdit, page: () => BusinessEdit()),
        GetPage(name: RouteName.products, page: () => ProductList()),
      ];
}
