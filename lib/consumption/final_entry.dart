import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'package:gp91/consumption/fuel_calculation.dart';
import 'package:gp91/consumption/fuel_firebase.dart';
import 'package:gp91/consumption/fuel_result.dart';
import 'package:gp91/consumption/instruction_card.dart';
import 'package:gp91/consumption/rounded_button_small.dart';
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
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form
  @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showAlertDialog(context);
  //   });
  // }

  // void showAlertDialog(BuildContext context) {
  //   // Set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: const Text("Fuel Expense Notification",
  //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
  //     content: const SingleChildScrollView(
  //       // Ensures content fits in smaller screens
  //       child: ListBody(
  //         children: <Widget>[
  //           Text(
  //               "Your car's initial fuel expense is set at 500 SR for this journey. "
  //               "This amount is a key factor in our fuel consumption calculation. "
  //               "If this estimate aligns with your expectations, you can proceed. "
  //               "However, if you have a different amount in mind based on the expected mileage traveled, "
  //               "please enter the new figure. This ensures that our calculations are tailored to your specific needs.",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       ElevatedButton(
  //         child: Text("Ok", style: TextStyle(color: Colors.white)),
  //         style: ElevatedButton.styleFrom(primary: Colors.green),
  //         onPressed: () {
  //           // Code to proceed
  //           Navigator.of(context).pop(); // Close the dialog
  //         },
  //       ),
  //     ],
  //   );

  //   // Show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  // Define the controller for end mileage
  final TextEditingController endMileageController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
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
          'Final mileage entry',
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

              return Form(
                // <-- Add the Form widget here
                key: _formKey,
                child: Column(
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.all(20.0),
                    //   child: Text(
                    //     "Note: you will not be able to enter the final odometer until the end of the month",
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.redAccent,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InstructionCard(
                          step: "Step 2",
                          icon: Icons.local_gas_station,
                          instruction: "Record the final odometer reading.",
                          color: Colors.redAccent,
                        ),
                        const Row(
                          children: [
                            Text(
                              "Expenses (optional): ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Tooltip(
                              message:
                                  "You can skip this field if you don't want to enter expenses.",
                              child: Icon(Icons.info_outline,
                                  size: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: expenseController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Enter expense amount (optional)',
                            prefixIcon: const Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.blue),
                          ),
                        ),
                        // TextFormField(
                        //   controller: expenseController,
                        //   keyboardType: TextInputType.number,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.white,
                        //     border: OutlineInputBorder(
                        //       borderSide: BorderSide.none,
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     hintText: 'Enter expense amount (optional)',
                        //     prefixIcon: const Icon(
                        //         Icons.monetization_on_outlined,
                        //         color: Colors.blue),
                        //   ),
                        //   validator: (value) {

                        //     if (double.tryParse(value!) == null) {
                        //       return 'Enter a valid number';
                        //     }
                        //     return null; // means validation passed
                        //   },
                        // ),
                        const SizedBox(height: 20),
                        const Text(
                          "Final Odometer Reading (Km): ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // TextField(
                        //   controller: endMileageController,
                        //   keyboardType: TextInputType.number,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.white,
                        //     border: OutlineInputBorder(
                        //       borderSide: BorderSide.none,
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     hintText: 'Enter Final reading',
                        //     prefixIcon: Icon(Icons.speed, color: Colors.blue),
                        //   ),
                        // ),
                        TextFormField(
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the final odometer reading';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter a valid number';
                            }
                            return null; // means validation passed
                          },
                        )
                      ],
                    ),

                    const SizedBox(height: 20),
                    RoundedButtonSmall(
                      text: "Submit",
                      press: () async {
                        if (_formKey.currentState!.validate()) {
                          // UI feedback for loading
                          // Implement any loading indicator or disable the button

                          try {
                            if (expenseController.text.isNotEmpty) {
                              double expense =
                                  double.parse(expenseController.text);
                              await FuelFirebase().updateAmountField(
                                  widget.carDocumentId, expense);
                            }
                            double startMileage =
                                double.tryParse(data['startMileage'] ?? '0') ??
                                    0.0;
                            print(startMileage);
                            double endMileage = double.tryParse(
                                    endMileageController.text ?? '0') ??
                                0.0;
                            print(endMileage);

                            DateTime currentTimestamp = DateTime.now();
                            String finalDate = DateFormat('yyyy-MM-dd')
                                .format(currentTimestamp);
                            double litersConsumed = await FuelCalculation()
                                .getLitersConsumed(widget.carDocumentId,
                                    data['startDate'], finalDate);
                            print("litersConsumed: ${litersConsumed}");

                            double calculatedFuelEconomy = FuelCalculation()
                                .getCalculatedFuelEconomy(
                                    litersConsumed, startMileage, endMileage);
                            print(
                                "calculatedFuelEconomy: ${calculatedFuelEconomy}");
                            String percentageDifference =
                                await FuelCalculation().getPercentageDifference(
                                    widget.carDocumentId,
                                    calculatedFuelEconomy);

                            // bool oneMonthPassed = isOneMonthPast(data);
                            // print(oneMonthPassed);
                            // if (oneMonthPassed) {
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
                            var result = await Get.to(() => const FuelResult(
                                // consumptionDocumentId: widget.consumptionId,
                                // carDocumentId: widget.carDocumentId,
                                ));

                            if (result != null) {
                              // Handle result if needed
                            }
                            // } else {
                            //   setState(() {
                            //     calculatedFuelEconomyResult = calculatedFuelEconomy;
                            //     percentageDifferenceResult = percentageDifference;
                            //     showResults = true;
                            //   });
                            // }
                          } catch (error) {
                            print("Error submitting data: ${error.toString()}");
                            Get.snackbar(
                              "Error",
                              "No bills found for this car.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.1),
                              colorText: Colors.red,
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (showResults) _buildResultsWidget(),
                    // BottomNav(
                    //   currentIndex: 0, // Set the initial index as needed
                    //   onIndexChanged: (index) {
                    //     // Handle index changes if required
                    //   },
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0, // Set the initial index as needed
        onIndexChanged: (index) {
          // Handle index changes if required
        },
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
                  'Percentage Difference: $percentageDifferenceResult',
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
    // Extract and split the date string based on the format YYYY-MM-DD
    String dateString = data['startDate'];
    List<String> dateParts =
        dateString.split('-').map((s) => s.trim()).toList();
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Create a DateTime object from the extracted date
    DateTime initialDateTime = DateTime(year, month, day);

    // Get the current date
    DateTime currentDateTime = DateTime.now();

    // Calculate the difference
    Duration difference = currentDateTime.difference(initialDateTime);

    // Check if the difference is at least a month (30 days)
    return difference.inDays >= 30;
  }
}
