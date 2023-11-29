import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'car_body.dart';

class CarPage extends StatelessWidget {
  const CarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Add any other widgets specific to the Station screen
          Expanded(
            child: CarBody(), // Create an instance of the CarBody widget
          ),
          BottomNav(
            currentIndex: 0, // Set the initial index as needed
            onIndexChanged: (index) {
              // Handle index changes if required
            },
          ),
        ],
      ),
    );
  }
}
