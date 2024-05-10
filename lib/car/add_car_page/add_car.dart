import 'package:flutter/material.dart';
import 'add_car_body.dart';

class AddCar extends StatelessWidget {
  const AddCar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          
          Expanded(
            child: AddCarBody(), // Create an instance of the CarBody widget
          ),
        ],
      ),
    );
  }
}
