enum BusinessCategory {
  MECHANICS,
  PADDY_TRANSPLANTORS,
  DRONES,
  HARVESTORS,
  AGRICULTURE_LABOR,
  EARTH_MOVERS,
  IMPLEMENTS,
  MACHINES,
}

extension BusinessCategoryExtension on BusinessCategory {
  String get name {
    switch (this) {
      case BusinessCategory.MECHANICS:
        return 'Mechanics';
      case BusinessCategory.PADDY_TRANSPLANTORS:
        return 'Paddy Transplantors';
      case BusinessCategory.DRONES:
        return 'Drones';
      case BusinessCategory.HARVESTORS:
        return 'Harvestors';
      case BusinessCategory.AGRICULTURE_LABOR:
        return 'Agriculture Labor';
      case BusinessCategory.EARTH_MOVERS:
        return 'Earth Movers';
      case BusinessCategory.IMPLEMENTS:
        return 'Implements';
      case BusinessCategory.MACHINES:
        return 'Machines';
      default:
        return '';
    }
  }

  // Get BusinessCategory enum from string
  static BusinessCategory? fromString(String name) {
    switch (name) {
      case 'Mechanics':
        return BusinessCategory.MECHANICS;
      case 'Paddy Transplantors':
        return BusinessCategory.PADDY_TRANSPLANTORS;
      case 'Drones':
        return BusinessCategory.DRONES;
      case 'Harvestors':
        return BusinessCategory.HARVESTORS;
      case 'Agriculture Labor':
        return BusinessCategory.AGRICULTURE_LABOR;
      case 'Earth Movers':
        return BusinessCategory.EARTH_MOVERS;
      case 'Implements':
        return BusinessCategory.IMPLEMENTS;
      case 'Machines':
        return BusinessCategory.MACHINES;
      default:
        return null;
    }
  }
}
