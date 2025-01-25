
import 'package:get/get.dart';

class HarvestorDetails {
  final List<String> images;
  final Map<String,String> imageWithTitle;
  final String hp;
  final String modelNo;
  final String type;
  final ProductStatus verificationStatus;
  RxDouble avgRating;
  final String id;
  final String? mobileNumber;
  final String? serviceProviderId;


  HarvestorDetails({
    required this.images,
    required this.hp,
    required this.modelNo,
    required this.type,
    required this.verificationStatus,
    required this.avgRating,
    required this.imageWithTitle,
    required this.id,
    required this.mobileNumber,
    required this.serviceProviderId
  });

  factory HarvestorDetails.fromJson(Map<String, dynamic> json) {
    return HarvestorDetails(
      imageWithTitle: Map<String,String>.from(json['images']),
      images:  List<String>.from(json['images'].values),
      hp: json['hp'] ?? 'Not-Defined',
      modelNo: json['modelNo'],
      type: json['type'] ?? 'Not-Defined',
      verificationStatus: ProductStatus.fromJson({'status': json['verificationStatus']}),
      avgRating: (json['avgRating'] as num).toDouble().obs,
      id : json['_id'],
      mobileNumber: json["business"] != null && json["business"] is Map && json["business"]["mobileNumber"] != null ? json["business"]["mobileNumber"] : null,
      serviceProviderId: json["business"] != null && json["business"] is Map && json["business"]["serviceProvider"] != null ? json["business"]["serviceProvider"] : null
    );
  }
}

class ProductStatus {
  final String status;

  ProductStatus({required this.status});

  factory ProductStatus.fromJson(Map<String, dynamic> map) {
    return ProductStatus(status: map['status']);
  }
}
