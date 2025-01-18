import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Utils/utils.dart';
import '../../dtos/agriculture_dto.dart';

class LaborItemCard extends StatelessWidget {
  final AgricultureLabor agricultureLabor;

  LaborItemCard({Key? key, required this.agricultureLabor}) : super(key: key);

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
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              height: 200,
              agricultureLabor.imageUrls.first,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'eShram Card: ${agricultureLabor.eShramCardNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      agricultureLabor.verificationStatus.status == 'Verified'
                          ? Icons.verified
                          : Icons.error,
                      color: agricultureLabor.verificationStatus.status ==
                          'Verified'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    SizedBox(width: 5.0),
                    Text(agricultureLabor.verificationStatus.status),
                  ],
                ),
                SizedBox(height: 5.0), // Ready to Travel Indicator
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
                          ? 'Ready to travel within 10 km'
                          : 'Not ready to travel beyond current location',
                    ),
                  ],
                ),
                SizedBox(height: 5.0), // Individual or Group Indicator
                Row(
                  children: [
                    Icon(
                      agricultureLabor.isIndividual
                          ? Icons.person
                          : Icons.people,
                    ),
                    SizedBox(width: 5.0),
                    Text(agricultureLabor.isIndividual
                        ? 'Individual Worker'
                        : '${agricultureLabor.numberOfWorkers} Workers'),
                  ],
                ),
                SizedBox(height: 5.0), // Services Offered
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
                        agricultureLabor.services[index].serviceName,
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
                const SizedBox(height: 5.0), // Average Rating
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: agricultureLabor.avgRating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                   const SizedBox(width: 5.0),
                    Text('${agricultureLabor.avgRating}'),
                   const Expanded(child: SizedBox()),
                    OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsets>(
                             const  EdgeInsets.symmetric(
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
