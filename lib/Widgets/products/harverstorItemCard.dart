import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Widgets/product_card_footer.dart';
import 'package:raithan_serviceapp/constants/enums/image_type.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/dtos/harverstor_dto.dart';
import 'package:shimmer/shimmer.dart';

import '../../Utils/utils.dart';
import '../../controller/auth_controller.dart';
import '../../controller/product_list_controller.dart';

class HarverstorItemCard extends StatelessWidget {
  final HarvestorDetails harvestorDetails;
  final String businessType;

  HarverstorItemCard(
      {Key? key, required this.harvestorDetails, required this.businessType})
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
          // Image Carousel
          cs.CarouselSlider(
            options: cs.CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: harvestorDetails.images.map((url) {
              return GestureDetector(
                onTap: () {
                  Utils.showImagePopup(context, url, ImageType.NETWORK_IMAGE);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (context, url, error) {
                      print(url);
                      return Text("Image Not Found $url");
                    },
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 216, 216, 216),
                          highlightColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          child: Container(
                            color: Colors.amber,
                          ));
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // eShramCardNumber
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'Model No'.tr} : ${harvestorDetails.modelNo}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      // Ensures proper alignment
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          harvestorDetails.verificationStatus.status ==
                                  'Verified'
                              ? Icons.verified
                              : Icons.error,
                          color: harvestorDetails.verificationStatus.status ==
                                  'Verified'
                              ? Colors.green
                              : Colors.orange,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...harvestorDetails.verificationStatus.status
                                .split(" ")
                                .map((part) {
                              return Text(
                                part.tr,
                                style: const TextStyle(
                                    fontSize: 14.0, height: 1.0),
                                // Adjust text height
                                maxLines: 2,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                // Truncates overflow text with ellipsis
                                softWrap:
                                    true, // Ensures wrapping happens at word boundaries
                              );
                            })
                          ],
                        )
                      ],
                    )
                  ],
                ),
                if (harvestorDetails.hp != 'Not-Defined') SizedBox(height: 5.0),
                // HP
                if (harvestorDetails.hp != 'Not-Defined')
                  Row(
                    children: [
                      Icon(
                        Icons.energy_savings_leaf_outlined,
                        size: 21,
                      ),
                      SizedBox(width: 5.0),
                      RichText(
                        text: TextSpan(
                          text: '${'HP'.tr} : ', // Bold text
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${harvestorDetails.hp}', // Normal text
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (harvestorDetails.type != 'Not-Defined')
                  SizedBox(height: 5.0),
                if (harvestorDetails.type != 'Not-Defined')
                  Row(
                    children: [
                      Icon(
                        Icons.agriculture,
                        size: 21,
                      ),
                      SizedBox(width: 5.0),
                      RichText(
                        text: TextSpan(
                          text: '${'Type'.tr} : ', // Bold text
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${harvestorDetails.type.tr}', // Normal text
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ProductCardFooter(
                    productDetails: harvestorDetails,
                    businessType: businessType,
                    userRole: authController.userRole,
                    rateUs: () {
                      ProductListController productListController = Get.find();
                      productListController.showFeedBackSheet(
                          context, harvestorDetails.id);
                    },
                    onCallNow: () {
                      ProductListController productListController = Get.find();
                      productListController.seekerInquiryCall(
                          context,
                          harvestorDetails.mobileNumber!,
                          harvestorDetails.serviceProviderId!);
                    },
                    onEdit: () {
                      Get.toNamed(RouteName.editProductDetails, arguments: {
                        'isEdit': true,
                        'productDetails': harvestorDetails,
                        'businessType': businessType
                      });
                    })
                // Row(
                //   children: [
                //     RatingBarIndicator(
                //       rating: harvestorDetails.avgRating,
                //       itemBuilder: (context, index) => const Icon(
                //         Icons.star,
                //         color: Colors.amber,
                //       ),
                //       itemCount: 5,
                //       itemSize: 20.0,
                //       direction: Axis.horizontal,
                //     ),
                //     SizedBox(width: 5.0),
                //     Text('${harvestorDetails.avgRating}'),
                //     Expanded(child: SizedBox()),
                //     OutlinedButton(
                //         onPressed: () {
                //           Get.toNamed(RouteName.editProductDetails,arguments: {
                //             'isEdit' : true,
                //             'productDetails' : harvestorDetails,
                //             'businessType' : businessType
                //           });
                //
                //         },
                //         style: ButtonStyle(
                //           padding: WidgetStateProperty.all<EdgeInsets>(
                //               EdgeInsets.symmetric(
                //                   vertical: 0, horizontal: 15)),
                //           shape:
                //               WidgetStateProperty.all<RoundedRectangleBorder>(
                //             RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(
                //                   12), // Adjust the radius as needed
                //             ),
                //           ),
                //         ),
                //         child: const Row(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Text("Edit"),
                //             SizedBox(
                //               width: 4,
                //             ),
                //             Icon(Icons.edit),
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
