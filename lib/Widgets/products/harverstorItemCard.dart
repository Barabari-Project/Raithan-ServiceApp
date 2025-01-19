import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/constants/enums/image_type.dart';
import 'package:raithan_serviceapp/constants/routes/app_route.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/dtos/harverstor_dto.dart';
import 'package:shimmer/shimmer.dart';

import '../../Utils/utils.dart';

class HarverstorItemCard extends StatelessWidget {
  final HarvestorDetails harvestorDetails;
  final String businessType;

  HarverstorItemCard({Key? key, required this.harvestorDetails, required this.businessType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
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
                  child: CachedNetworkImage(imageUrl: url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (context,url,error){
                    print(url);
                      return Text("Image Not Found $url");
                    },
                    placeholder: (context,url){
                      return Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 216, 216, 216),
                          highlightColor: const Color.fromARGB(255, 255, 255, 255),
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
                  children: [
                    Text(
                      'Model No : ${harvestorDetails.modelNo}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      harvestorDetails.verificationStatus.status == 'Verified'
                          ? Icons.verified
                          : Icons.error,
                      color: harvestorDetails.verificationStatus.status ==
                              'Verified'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    SizedBox(width: 5.0),
                    Text(harvestorDetails.verificationStatus.status),
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
                          text: 'HP : ', // Bold text
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
                          text: 'Type : ', // Bold text
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${harvestorDetails.type}', // Normal text
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
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: harvestorDetails.avgRating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                    SizedBox(width: 5.0),
                    Text('${harvestorDetails.avgRating}'),
                    Expanded(child: SizedBox()),
                    OutlinedButton(
                        onPressed: () {
                          Get.toNamed(RouteName.editProductDetails,arguments: {
                            'isEdit' : true,
                            'productDetails' : harvestorDetails,
                            'businessType' : businessType
                          });

                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Adjust the radius as needed
                            ),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Edit"),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(Icons.edit),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
