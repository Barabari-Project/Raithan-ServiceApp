enum AgricultureLaborServiceType {
  SOWING_DRYLANDS('Sowing Drylands'),
  TRANSPLANTATION_WETLANDS('Transplantation Wetlands'),
  WEEDING_DRYLANDS('Weeding Drylands'),
  WEEDING_WETLANDS('Weeding Wetlands'),
  FERTILIZATION_DRYLANDS('Fertilization Drylands'),
  FERTILIZATION_WETLANDS('Fertilization Wetlands'),
  SPRAYING_DRYLANDS_WITH_HAND_PUMP('Spraying Drylands with Hand pump'),
  SPRAYING_DRYLANDS_WITH_BATTERY_PUMP('Spraying Drylands with Battery pump'),
  SPRAYING_DRYLANDS_WITH_PETROL_PUMP('Spraying Drylands with Petrol pump'),
  SPRAYING_WETLANDS_WITH_HAND_PUMP('Spraying Wetlands with Hand pump'),
  SPRAYING_WETLANDS_WITH_BATTERY_PUMP('Spraying Wetlands with Battery pump'),
  SPRAYING_WETLANDS_WITH_PETROL_PUMP('Spraying Wetlands with Petrol pump'),
  HARVESTING_COMMERCIAL_CROPS('Harvesting Commercial Crops'),
  HARVESTING_FRUITS_CROPS('Harvesting Fruits Crops'),
  HARVESTING_VEGETABLES_CROPS('Harvesting Vegetables Crops'),
  HARVESTING_CROPS('Harvesting Crops');

  final String description;

  const AgricultureLaborServiceType(this.description);

  @override
  String toString() => description;

}
