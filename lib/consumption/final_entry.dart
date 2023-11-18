import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/consumption/fuel_firebase.dart';
import 'package:gp91/consumption/fuel_prev.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:intl/intl.dart';

class FinalEntry extends StatelessWidget {
  final String documentID;

  const FinalEntry({
    super.key,
    required this.documentID,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController startMileageController =
        TextEditingController();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: FuelFirebase().fetchDoc(documentID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Text("Error fetching data");
              }

              bool oneMonthPassed = isOneMonthPast(snapshot.data!);
              print(oneMonthPassed
                  ? "A month has passed"
                  : "Less than a month has passed");

              return Column(
                children: [
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
                    controller: startMileageController,
                    keyboardType: TextInputType.number,
                    enabled:
                        oneMonthPassed, // Enable or disable based on the condition
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
                  RoundedButton(
                    text: "Submit",
                    press: () {
                      if (oneMonthPassed) {
                        // Proceed with submitting logic
                        // How do you want the analysis to be?
                        // the UI style
                      } else {
                        // Show notification
                        Get.snackbar(
                          "Wait",
                          "A month has not yet passed since the initial reading",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          colorText: Colors.red,
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool isOneMonthPast(Map<String, dynamic> data) {
    // Extract and split the date string
    String dateString = data['initialMileage']['date'];
    List<String> dateParts =
        dateString.split(', ').map((s) => s.trim()).toList();
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Extract and parse the time string
    String timeString = data['initialMileage']['time'];
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
