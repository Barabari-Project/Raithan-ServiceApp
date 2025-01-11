import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Utils/app_dimensions.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;

  NetworkImageWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheImage(NetworkImage(imageUrl), context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: AppDimensions.width * 0.4,
              // Adjust size
              width: AppDimensions.width * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
            ),
          );
        }
      },
    );
  }
}
