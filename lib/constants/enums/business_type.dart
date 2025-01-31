enum BusinessType {
  UNREGISTERED('Business - Unregistered'),
  REGISTERED_PROPRIETORSHIP('Business - Registered / Proprietorship'),
  REGISTERED_PARTNERSHIP('Business - Registered / Partnership'),
  REGISTERED_PVT_LTD('Business - Registered / Pvt Ltd'),
  INDIVIDUAL('Individual'),
  INDIVIDUAL_CONSULTANT('Individual Consultant');

  final String description;

  const BusinessType(this.description);

  @override
  String toString() => description;
}
