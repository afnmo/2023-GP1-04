class Car {
  final String carId;
  final String name;
  // Other car details as needed.

  Car({
    required this.carId,
    required this.name,
  });
}

class ConsumptionRecord {
  final String carId;
  final double calculatedFuelEconomy;
  final String startDate;
  final String endDate;
  final String percentageDifference;

  ConsumptionRecord({
    required this.carId,
    required this.calculatedFuelEconomy,
    required this.startDate,
    required this.endDate,
    required this.percentageDifference,
  });
}
