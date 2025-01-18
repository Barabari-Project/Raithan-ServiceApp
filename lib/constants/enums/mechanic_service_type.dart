enum MechanicServiceType {
  ELECTRIC_WATER_PUMP('Electric Water Pump'),
  DIESEL_WATER_PUMP('Diesel Water Pump'),
  SOLAR_WATER_PUMP('Solar Water Pump'),
  TRACTOR_REPAIR('Tractor Repair');

  final String description;

  const MechanicServiceType(this.description);

  @override
  String toString() => description;
  
}
