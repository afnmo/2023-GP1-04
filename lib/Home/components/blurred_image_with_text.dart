import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/car/add_car_page/add_car.dart';
import 'dart:ui' as ui;
// import 'package:gp91/car/car.dart';

class BlurredImageWithText extends StatelessWidget {
  const BlurredImageWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
      // ignore: sized_box_for_whitespace
      child: Container(
        height: 200,
        child: ClipRect(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/chart.png', // set the image asset
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: BackdropFilter(
                  //blurr the image
                  filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: const Color(0xFF6EA67C)
                        .withOpacity(0.3), // Adjust the opacity as needed
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //add text over the blurr
                    const Text(
                      'Want to know your gas costs?\nAdd a car, \nand monitor your costs!',
                      style: TextStyle(
                        color: Color(0xFF6EA67C),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // on prees go add car
                        Get.to(() => const AddCar());
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF6EA67C),
                        ),
                      ),
                      // the text in the button
                      child: const Text('Add Cars'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
