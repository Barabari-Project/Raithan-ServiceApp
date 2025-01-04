import 'package:get/get.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/profile.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/Pages/provider_home.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(name: RouteName.splashScreen, page: () => ProviderHome()),
        GetPage(name: RouteName.profile, page: () => Profile()),
        GetPage(name: RouteName.provider_home, page: () => ProviderHome()),
      ];
}
