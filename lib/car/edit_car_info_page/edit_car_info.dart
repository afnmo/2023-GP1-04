import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'edit_car_info_body.dart';

class EditCarInfo extends StatelessWidget {
  final String carId;

  EditCarInfo({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Add any other widgets specific to the Station screen
          Expanded(
            child: EditCarInfoBody(
                carId: carId), // Create an instance of the CarBody widget
          ),
          // BottomNav(
          //   currentIndex: 0, // Set the initial index as needed
          //   onIndexChanged: (index) {
          //     // Handle index changes if required
          //   },
          // ),
        ],
      ),
    );
  }
}
