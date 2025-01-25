

import 'package:get/get.dart';

class AgricultureLabor {
  final String eShramCardNumber;
  final bool readyToTravelIn10Km;
  final bool isIndividual;
  final List<AgricultureLaborServiceType> services;
  final Map<String,String> imageWithTitle;
  final int numberOfWorkers;
  final ProductStatus verificationStatus;
  RxDouble avgRating;
  final List<String> imageUrls;
  final String? mobileNumber;
  final String id;
  final String? serviceProviderId;

  AgricultureLabor({
    required this.eShramCardNumber,
    required this.readyToTravelIn10Km,
    required this.isIndividual,
    required this.services,
    required this.numberOfWorkers,
    required this.verificationStatus,
    required this.avgRating,
    required this.imageUrls,
    required this.id,
    required this.imageWithTitle,
    required this.mobileNumber,
    required this.serviceProviderId
  });

  factory AgricultureLabor.fromJson(Map<String, dynamic> json) {
    return AgricultureLabor(
      eShramCardNumber: json['eShramCardNumber'],
      readyToTravelIn10Km: json['readyToTravelIn10Km'],
      isIndividual: json['isIndividual'],
      services: (json['services'] as List)
          .map((service) => AgricultureLaborServiceType.fromJson({'serviceName': service}))
          .toList(),
      numberOfWorkers: json['numberOfWorkers'],
      verificationStatus: ProductStatus.fromJson({'status': json['verificationStatus']}),
      avgRating : (json['avgRating'] as num).toDouble().obs,
      imageUrls: List<String>.from(json['images'].values),
      imageWithTitle: Map<String,String>.from(json['images']),
      id: json['_id'],
      mobileNumber: json["business"] != null && json["business"] is Map && json["business"]["mobileNumber"] != null ? json["business"]["mobileNumber"] : null,
      serviceProviderId: json["business"] != null && json["business"] is Map && json["business"]["serviceProvider"] != null ? json["business"]["serviceProvider"] : null
    );
  }
}


class AgricultureLaborServiceType {
  final String serviceName;

  AgricultureLaborServiceType({required this.serviceName});

  static AgricultureLaborServiceType fromJson(Map<String, dynamic> map) {
    return AgricultureLaborServiceType(serviceName: map['serviceName']);
  }
}

class ProductStatus {
  final String status;

  ProductStatus({required this.status});

  static fromJson(Map<String, dynamic> map) {
    return ProductStatus(status: map['status']);
  }
}