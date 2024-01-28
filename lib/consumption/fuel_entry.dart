import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'package:gp91/consumption/fuel_firebase.dart';
import 'package:gp91/consumption/fuel_prev.dart';
import 'package:gp91/consumption/instruction_card.dart';
import 'package:gp91/consumption/rounded_button_small.dart';
import 'package:intl/intl.dart';

class FuelEntry extends StatefulWidget {
  final String carDocumentId;

  FuelEntry({super.key, required this.carDocumentId});

  @override
  _FuelEntryState createState() => _FuelEntryState();
}

class _FuelEntryState extends State<FuelEntry> {
  final TextEditingController _startMileageController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form

  @override
  void initState() {
    super.initState();
    _prefillStartMileage();
  }

  void _prefillStartMileage() async {
    var finalMileage =
        await FuelFirebase().getMostRecentFinalMileage(widget.carDocumentId);
    print(
        "finalMileage: ${finalMileage}"); // Replace with your function to fetch finalMileage
    if (finalMileage != null) {
      setState(() {
        print("finalMileage: ${finalMileage}");
        _startMileageController.text = finalMileage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _startMileageController =
    //     TextEditingController();

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
          'Initial mileage entry',
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const InstructionCard(
                  step: "Step 1",
                  icon: Icons.local_gas_station,
                  instruction: "Record the initial odometer reading.",
                  color: Colors.orangeAccent,
                ),
                // const InstructionCard(
                //   step: "Step 2",
                //   icon: Icons.drive_eta,
                //   instruction:
                //       "Continue using your vehicle as normal until the end of the month.",
                //   color: Colors.greenAccent,
                // ),
                // const InstructionCard(
                //   step: "Step 3",
                //   icon: Icons.local_gas_station,
                //   instruction: "Record the final odometer reading.",
                //   color: Colors.redAccent,
                // ),
                const SizedBox(height: 20),
                const Text(
                  "Initial Odometer Reading (Km): ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _startMileageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter initial reading',
                    prefixIcon: Icon(Icons.speed, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter initial reading';
                    }
                    if (!RegExp(r'^\d+\.?\d*$').hasMatch(value)) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                RoundedButtonSmall(
                  text: "Submit",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      DateTime currentTimestamp = DateTime.now();

                      await FuelFirebase().addMileage({
                        'startMileage': _startMileageController.text,
                        'startDate':
                            DateFormat('yyyy-MM-dd').format(currentTimestamp),
                        'startTime': DateFormat.jms().format(currentTimestamp),
                        'carId': widget.carDocumentId,
                        'done': false,
                      });

                      Get.to(
                        () => FuelPrev(
                            // carDocumentId: carDocumentId,
                            ),
                      );
                    }
                  },
                ),
              ],
            ),
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
}
