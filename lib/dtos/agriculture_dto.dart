

class AgricultureLabor {
  final String eShramCardNumber;
  final bool readyToTravelIn10Km;
  final bool isIndividual;
  final List<AgricultureLaborServiceType> services;
  final int numberOfWorkers;
  final ProductStatus verificationStatus;
  final double avgRating;
  final List<String> imageUrls;

  AgricultureLabor({
    required this.eShramCardNumber,
    required this.readyToTravelIn10Km,
    required this.isIndividual,
    required this.services,
    required this.numberOfWorkers,
    required this.verificationStatus,
    required this.avgRating,
    required this.imageUrls,
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
      avgRating: (json['avgRating'] as num).toDouble(),
      imageUrls: List<String>.from(json['images']),
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