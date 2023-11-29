import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'addCarBody.dart';

class addCar extends StatelessWidget {
  const addCar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          // Add any other widgets specific to the Station screen
          Expanded(
            child: addCarBody(), // Create an instance of the CarBody widget
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
