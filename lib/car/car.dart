import 'package:flutter/material.dart';
import 'car_body.dart';

class CarPage extends StatelessWidget {
  const CarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CarBody(
              isConsumption: false,
            ), // Create an instance of the CarBody widget
          ),
        ],
      ),
    );
  }
}
