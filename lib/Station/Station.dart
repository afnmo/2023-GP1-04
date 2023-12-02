import 'package:flutter/material.dart';
import 'package:gp91/Station/Body_Station.dart';
import 'package:gp91/components/bottom_nav.dart';

class Station extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Add any other widgets specific to the Station screen
          Expanded(
            child: BodyStation(),
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
