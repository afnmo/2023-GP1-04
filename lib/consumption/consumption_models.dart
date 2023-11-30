class Car {
  final String carId;
  final String name;

  Car({
    required this.carId,
    required this.name,
  });
}

class ConsumptionRecord {
  final String carId;
  final String? consumptionId;

  final double? calculatedFuelEconomy;
  final String? startDate;
  final String? endDate;
  final String? percentageDifference;
  final String? startMileage;

  ConsumptionRecord({
    required this.carId,
    this.consumptionId,
    this.calculatedFuelEconomy,
    this.startDate,
    this.endDate,
    this.percentageDifference,
    this.startMileage,
  });
}
