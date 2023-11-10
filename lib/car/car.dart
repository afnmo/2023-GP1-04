import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'carBody.dart'; // Assuming carBody.dart contains your carBody widget

void main() {
  runApp(
    MaterialApp(
      home: CarApp(),
    ),
  );
}

class CarApp extends StatelessWidget {
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
