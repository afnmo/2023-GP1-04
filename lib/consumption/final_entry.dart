import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gp91/consumption/fuel_calculation.dart';
import 'package:gp91/consumption/fuel_firebase.dart';
import 'package:gp91/consumption/fuel_result.dart';
import 'package:gp91/consumption/rounded_button_small.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:intl/intl.dart';

class FinalEntry extends StatefulWidget {
  final String consumptionId;
  final String carDocumentId;

  FinalEntry({
    super.key,
    required this.consumptionId,
    required this.carDocumentId,
  });

  @override
  State<StatefulWidget> createState() => _FinalEntryState();
}

class _FinalEntryState extends State<FinalEntry> {
  // Define the controller for end mileage
  final TextEditingController endMileageController = TextEditingController();
  bool showResults = false;
  // Define variables for your results
  double? calculatedFuelEconomyResult;
  String? percentageDifferenceResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6EA67C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Cars',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: FuelFirebase().fetchConsumptionDoc(widget.consumptionId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text("Error fetching data: ${snapshot.error}");
              }

              if (!snapshot.hasData) {
                return const Text("No data available");
              }

              Map<String, dynamic> data = snapshot.data!;

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Note: you will not be able to enter the final odometer until the end of the month",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Final Odometer Reading (Km): ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: endMileageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter Final reading',
                      prefixIcon: Icon(Icons.speed, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RoundedButtonSmall(
                    text: "Submit",
                    press: () async {
                      // UI feedback for loading
                      // Implement any loading indicator or disable the button
                      try {
                        double startMileage =
                            double.tryParse(data['startMileage'] ?? '0') ?? 0.0;
                        print(startMileage);
                        double endMileage =
                            double.tryParse(endMileageController.text ?? '0') ??
                                0.0;
                        print(endMileage);

                        DateTime currentTimestamp = DateTime.now();
                        String finalDate =
                            DateFormat('yyyy-MM-dd').format(currentTimestamp);
                        double litersConsumed = await FuelCalculation()
                            .getLitersConsumed(widget.carDocumentId,
                                data['startDate'], finalDate);
                        print("litersConsumed: ");
                        print(litersConsumed);

                        double calculatedFuelEconomy = FuelCalculation()
                            .getCalculatedFuelEconomy(
                                litersConsumed, startMileage, endMileage);
                        print("calculatedFuelEconomy:");
                        print(calculatedFuelEconomy);
                        String percentageDifference = await FuelCalculation()
                            .getPercentageDifference(
                                widget.carDocumentId, calculatedFuelEconomy);

                        bool oneMonthPassed = isOneMonthPast(data);
                        print(oneMonthPassed);
                        if (oneMonthPassed) {
                        await FuelFirebase().addFinalInputs(
                          {
                            'endMileage': endMileageController.text,
                            'finalDate': finalDate,
                            'finalTime':
                                DateFormat.jms().format(currentTimestamp),
                            'done': true,
                            'calculatedFuelEconomy': calculatedFuelEconomy,
                            'percentageDifference': percentageDifference,
                          },
                          widget.consumptionId,
                        );

                        // Handling navigation result
                        var result = await Get.to(() => FuelResult(
                              consumptionDocumentId: widget.consumptionId,
                              carDocumentId: widget.carDocumentId,
                            ));

                        if (result != null) {
                          // Handle result if needed
                        }

                        } else {
                          setState(() {
                            calculatedFuelEconomyResult = calculatedFuelEconomy;
                            percentageDifferenceResult = percentageDifference;
                            showResults = true;
                          });
                        }
                      } catch (error) {
                        print("Error submitting data: ${error.toString()}");
                        Get.snackbar(
                          "Error",
                          "Failed to submit data. Please try again.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          colorText: Colors.red,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (showResults) _buildResultsWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Icon(Icons.local_gas_station, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Fuel Economy: $calculatedFuelEconomyResult Km/L',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 56, 54, 53),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Icon(Icons.trending_up, color: Colors.redAccent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Percentage Difference: $percentageDifferenceResult%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 56, 54, 53),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Add more result widgets as needed, with similar styling
      ],
    );
  }
  // Widget _buildResultsWidget() {
  //   return Text('Start Mileage: $startMileageResult');
  // }

  bool isOneMonthPast(Map<String, dynamic> data) {
    // Extract and split the date string
    String dateString = data['startDate'];
    List<String> dateParts =
        dateString.split(', ').map((s) => s.trim()).toList();
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Extract and parse the time string
    String timeString = data['startTime'];
    // Removing non-numeric characters from the seconds part
    String cleanTimeString =
        timeString.replaceAll(RegExp(r'[^0-9:APMapm]'), '');
    List<String> timeParts = cleanTimeString.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    // Extract seconds and AM/PM part
    String secondPart = timeParts[2];
    int second = int.parse(RegExp(r'\d+').firstMatch(secondPart)![0]!);
    // Adjust for AM/PM
    if (secondPart.contains('PM') && hour < 12) hour += 12;
    if (secondPart.contains('AM') && hour == 12) hour = 0;

    // Create a DateTime object from the extracted date and time
    DateTime initialDateTime = DateTime(year, month, day, hour, minute, second);

    // Get the current date and time
    DateTime currentDateTime = DateTime.now();

    // Calculate the difference
    Duration difference = currentDateTime.difference(initialDateTime);

    // Check if the difference is at least a month (30 days)
    return difference.inDays >= 30;
  }
}
