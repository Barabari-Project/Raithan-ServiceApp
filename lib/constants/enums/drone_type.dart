enum DroneType {
  FOR_SPRAYING('For Spraying'),
  FARMER_MONITORING('Farmer Monitoring');

  final String description;

  const DroneType(this.description);

  @override
  String toString() => description;

}