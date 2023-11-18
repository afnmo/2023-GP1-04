import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/consumption/fuel_firebase.dart';
import 'package:gp91/consumption/fuel_prev.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:intl/intl.dart';

class FuelEntry extends StatelessWidget {
  FuelEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _startMileageController =
        TextEditingController();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const InstructionCard(
                step: "Step 1",
                icon: Icons.local_gas_station,
                instruction: "Record the initial odometer.",
                color: Colors.orangeAccent,
              ),
              const InstructionCard(
                step: "Step 2",
                icon: Icons.drive_eta,
                instruction:
                    "Continue using your vehicle as normal until the end of the month.",
                color: Colors.greenAccent,
              ),
              const InstructionCard(
                step: "Step 3",
                icon: Icons.local_gas_station,
                instruction: "Record the final odometer reading.",
                color: Colors.redAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                "Initial Odometer Reading (Km): ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _startMileageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // labelText: "Initial Odometer Reading (Km)",
                  hintText: 'Enter initial reading',
                  prefixIcon: Icon(Icons.speed, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              RoundedButton(
                text: "Submit",
                press: () async {
                  DateTime currentTimestamp = DateTime.now();

                  // Pass these components to the toJson method
                  await FuelFirebase().addMileage(toJson({
                    'startMileage': _startMileageController.text,
                    'date': DateFormat('d, MM, yyyy').format(currentTimestamp),
                    'time': DateFormat.jms().format(currentTimestamp),
                  }));

                  Get.to(
                    () => FuelPrev(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  toJson(json) {
    return {
      "initialMileage": json,
    };
  }
}

class InstructionCard extends StatelessWidget {
  final String step;
  final IconData icon;
  final String instruction;
  final Color color;

  const InstructionCard({
    Key? key,
    required this.step,
    required this.icon,
    required this.instruction,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(instruction, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}