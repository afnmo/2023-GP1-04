import 'package:flutter/material.dart';
import 'car_info_body.dart';

class CarInfo extends StatelessWidget {
  final String carId;

  CarInfo({super.key, required this.carId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CarInfoBody(
                carId: carId), // Create an instance of the CarBody widget
          ),
        ],
      ),
    );
  }
}

