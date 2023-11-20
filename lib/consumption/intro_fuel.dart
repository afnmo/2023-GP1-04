import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/consumption/fuel_cars.dart';
import 'package:gp91/consumption/fuel_entry.dart';

class IntroFuel extends StatelessWidget {
  const IntroFuel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // big logo
            Padding(
              padding: const EdgeInsets.only(
                left: 100.0,
                right: 100.0,
                top: 80,
                bottom: 20,
              ),
              child: Image.asset('assets/images/gas.png'),
            ),

            // we deliver groceries at your doorstep
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                'Fuel Consumption',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),

            // groceree gives you fresh vegetables and fruits
            Text(
              'Your personal fuel consumption tracker',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 40),

            // const Spacer(),

            // get started button
            GestureDetector(
              // onTap: () => Get.to(() => FuelEntry()),
              onTap: () => Get.to(() => FuelCars()),
              
              // => Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return HomePage();
              //     },
              //   ),
              // ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: btnColor,
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
