import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
//import 'package:gp91/components/constants.dart';
//import 'package:../components/constants.dart';
import 'Body_Station.dart';

class Station extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Add any other widgets specific to the Station screen
          Expanded(
            child: Body_Station(),
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
