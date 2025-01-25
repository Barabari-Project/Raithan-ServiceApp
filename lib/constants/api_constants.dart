
class APIConstants{

   static const String baseUrl = "https://backend.barabaricollective.org";
   // static const String baseUrl = "https://cc60-2406-b400-d11-33ad-5cde-919c-64b1-e917.ngrok-free.app";

   static const String providerSentOTP = "/raithan/api/service-providers/onboard/user/mobile";

   static const String providerRegistartionVerifyOTP = "/raithan/api/service-providers/onboard/user/verify-otp";

   static const String providerLoginSentOTP = "/raithan/api/service-providers/login";

   static const String providerLoginVerifyOTP = "/raithan/api/service-providers/login/verify-otp";

   static const String providerSaveProfileDetails = "/raithan/api/service-providers/onboard/user/profile";

   static const String providerSaveBusinessDetails = "/raithan/api/business";

   static const String providerGetProfileDetails = "/raithan/api/service-providers/profile";

   static const String providerGetBusinessDetails = "/raithan/api/business/user/";

   static const String providerCoordinates = "/raithan/api/business/location";

   static const String providerGetProductsDetails = "/raithan/api/service-providers/products";

   static const String saveDroneDetails = "/raithan/api/products/create/drones";

   static const String saveProductDetails = "/raithan/api/products/create/vehicle";

   static const String editDroneDetails = "/raithan/api/products/update/drones";

   static const String editProductDetails = "/raithan/api/products/update/vehicle";

   static const String saveLaborDetails = "/raithan/api/products/create/labour-mechanics";

   static const String editLaborDetails = "/raithan/api/products/update/labour-mechanics";

   static const String seekerGetProductsDetails = "/raithan/api/service-seekers/get-products";

   static const String seekerLoginSentOTP = "/raithan/api/service-seekers/login";

   static const String seekerLoginVerifyOTP = "/raithan/api/service-seekers/login/verify-otp";

   static const String seekerCallEvent = "/raithan/api/service-seekers/call-event";

   static const String seekerRating = "/raithan/api/products/rating";

}
