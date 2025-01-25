import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Widgets/product_card_footer.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/controller/product_list_controller.dart';

import '../../Utils/utils.dart';
import '../../constants/enums/image_type.dart';
import '../../dtos/agriculture_dto.dart';

class LaborItemCard extends StatelessWidget {
  final AgricultureLabor agricultureLabor;
  final String businessType;

  LaborItemCard(
      {Key? key, required this.agricultureLabor, required this.businessType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            child: GestureDetector(
              onTap: () {
                Utils.showImagePopup(context, agricultureLabor.imageUrls.first,
                    ImageType.NETWORK_IMAGE);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Utils.getCachedNetworkImage(
                    agricultureLabor.imageUrls.first),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'eShram Card'.tr} : ${agricultureLabor.eShramCardNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start, // Ensures proper alignment
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          agricultureLabor.verificationStatus.status == 'Verified'
                              ? Icons.verified
                              : Icons.error,
                          color: agricultureLabor.verificationStatus.status == 'Verified'
                              ? Colors.green
                              : Colors.orange,
                        ),
                        SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...agricultureLabor.verificationStatus.status.split(" ").map((part){
                              return  Text(
                                part.tr,
                                style: const TextStyle(fontSize: 14.0, height: 1.0), // Adjust text height
                                maxLines: 2,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis, // Truncates overflow text with ellipsis
                                softWrap: true, // Ensures wrapping happens at word boundaries
                              );
                            })
                          ],
                        )
                      ],
                    )

                  ],
                ),
                SizedBox(height: 5.0),
                // Ready to Travel Indicator
                Row(
                  children: [
                    Icon(
                      agricultureLabor.readyToTravelIn10Km
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: agricultureLabor.readyToTravelIn10Km
                          ? Colors.green
                          : Colors.red,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      agricultureLabor.readyToTravelIn10Km
                          ? 'Ready to travel within 10 km'.tr
                          : 'Not ready to travel beyond current location'.tr,
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                // Individual or Group Indicator
                Row(
                  children: [
                    Icon(
                      agricultureLabor.isIndividual
                          ? Icons.person
                          : Icons.people,
                    ),
                    SizedBox(width: 5.0),
                    Text(agricultureLabor.isIndividual
                        ? 'Individual Worker'.tr
                        : '${agricultureLabor.numberOfWorkers} ${'Workers'.tr}'),
                  ],
                ),
                SizedBox(height: 5.0),
                // Services Offered
                Wrap(
                  spacing: 5.0,
                  children:
                      List.generate(agricultureLabor.services.length, (index) {
                    Color baseColor = Utils.getBackgroundColorByIndex(index);
                    Color frontColor = Utils.getColorByIndex(index);

                    return Chip(
                      padding: const EdgeInsets.all(3),
                      backgroundColor: baseColor,
                      label: Text(
                        agricultureLabor.services[index].serviceName.tr,
                        // Assuming `serviceName` is the label
                        style: TextStyle(
                          color: frontColor,
                          // Set the label color based on the index
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: frontColor,
                          width: 1.0,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 5.0),
                // Average Rating
                ProductCardFooter(
                    productDetails: agricultureLabor,
                    businessType: businessType,
                    userRole: authController.userRole,
                    rateUs: (){
                        ProductListController productListController = Get.find();
                        productListController.showFeedBackSheet(context,agricultureLabor.id);
                    },
                    onCallNow: () {
                      ProductListController productListController = Get.find();
                      productListController.seekerInquiryCall(context,agricultureLabor.mobileNumber!,agricultureLabor.serviceProviderId!);
                    },
                    onEdit: () {
                      Get.toNamed(RouteName.editLaborDetails, arguments: {
                        'businessType': businessType,
                        'isEdit': true,
                        'productDetails': agricultureLabor
                      });
                    })
                // Row(
                //   children: [
                //     RatingBarIndicator(
                //       rating: agricultureLabor.avgRating,
                //       itemBuilder: (context, index) => const Icon(
                //         Icons.star,
                //         color: Colors.amber,
                //       ),
                //       itemCount: 5,
                //       itemSize: 20.0,
                //       direction: Axis.horizontal,
                //     ),
                //    const SizedBox(width: 5.0),
                //     Text('${agricultureLabor.avgRating}'),
                //    const Expanded(child: SizedBox()),
                //     OutlinedButton(
                //         onPressed: () {
                //           if (authController.userRole.value == "PROVIDER") {
                //             Get.toNamed(RouteName.editLaborDetails, arguments: {
                //               'businessType': businessType,
                //               'isEdit': true,
                //               'productDetails': agricultureLabor
                //             });
                //           }
                //           else{
                //             ProductListController productListController = Get.find();
                //             productListController.showBottomSheet(context,agricultureLabor.id, agricultureLabor.mobileNumber!);
                //           }
                //         },
                //         style: ButtonStyle(
                //           padding: WidgetStateProperty.all<EdgeInsets>(
                //              const  EdgeInsets.symmetric(
                //                   vertical: 0, horizontal: 15)),
                //           shape:
                //           WidgetStateProperty.all<RoundedRectangleBorder>(
                //             RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(
                //                   12), // Adjust the radius as needed
                //             ),
                //           ),
                //         ),
                //         child:  Row(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Text( authController.userRole.value == "PROVIDER" ? "Edit" : "Call Now"),
                //             SizedBox(
                //               width: 4,
                //             ),
                //             Icon(authController.userRole.value == "PROVIDER" ? Icons.edit : Icons.call),
                //           ],
                //         )),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
