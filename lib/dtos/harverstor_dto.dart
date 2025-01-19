
class HarvestorDetails {
  final List<String> images;
  final Map<String,String> imageWithTitle;
  final String hp;
  final String modelNo;
  final String type;
  final ProductStatus verificationStatus;
  final double avgRating;
  final String id;

  HarvestorDetails({
    required this.images,
    required this.hp,
    required this.modelNo,
    required this.type,
    required this.verificationStatus,
    required this.avgRating,
    required this.imageWithTitle,
    required this.id
  });

  factory HarvestorDetails.fromJson(Map<String, dynamic> json) {
    return HarvestorDetails(
      imageWithTitle: Map<String,String>.from(json['images']),
      images:  List<String>.from(json['images'].values),
      hp: json['hp'] ?? 'Not-Defined',
      modelNo: json['modelNo'],
      type: json['type'] ?? 'Not-Defined',
      verificationStatus: ProductStatus.fromJson({'status': json['verificationStatus']}),
      avgRating: (json['avgRating'] as num).toDouble(),
      id : json['_id']
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
