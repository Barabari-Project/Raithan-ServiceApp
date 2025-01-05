import 'package:get/get.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/profile.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/provider_home.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/login.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/registration.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(name: RouteName.splashScreen, page: () => Registration()),
        GetPage(name: RouteName.profile, page: () => Profile()),
        GetPage(name: RouteName.provider_home, page: () => ProviderHome()),
        GetPage(name: RouteName.login, page: () => Registration()),
        GetPage(name: RouteName.registration, page: () => LoginScreen()),
      ];
}
