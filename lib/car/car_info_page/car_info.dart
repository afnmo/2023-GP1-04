import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'car_info_body.dart';

class CarInfo extends StatelessWidget {
  final String carId;

  CarInfo({super.key, required this.carId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Add any other widgets specific to the Station screen
          Expanded(
            child: CarInfoBody(
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
