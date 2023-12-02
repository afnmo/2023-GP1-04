import 'package:flutter/material.dart';
import 'edit_car_info_body.dart';

class EditCarInfo extends StatelessWidget {
  final String carId;

  EditCarInfo({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: EditCarInfoBody(
                carId: carId), // Create an instance of the CarBody widget
          ),
        ],
      ),
    );
  }
}
