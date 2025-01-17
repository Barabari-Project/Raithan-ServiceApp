class HarvestorDetails {
  final List<String> images;
  final String hp;
  final String modelNo;
  final String type;
  final ProductStatus verificationStatus;
  final double avgRating;

  HarvestorDetails({
    required this.images,
    required this.hp,
    required this.modelNo,
    required this.type,
    required this.verificationStatus,
    required this.avgRating,
  });

  factory HarvestorDetails.fromJson(Map<String, dynamic> json) {
    return HarvestorDetails(
      images: List<String>.from(json['images']),
      hp: json['hp'] ?? 'Not-Defined',
      modelNo: json['modelNo'],
      type: json['type'] ?? 'Not-Defined',
      verificationStatus: ProductStatus.fromJson({'status': json['verificationStatus']}),
      avgRating: (json['avgRating'] as num).toDouble(),
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
