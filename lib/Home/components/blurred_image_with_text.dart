import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BlurredImageWithText extends StatelessWidget {
  const BlurredImageWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
      child: Container(
        height: 200,
        child: ClipRect(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/chart.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: BackdropFilter(
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
                        // Add car button action
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF6EA67C),
                        ),
                      ),
                      child: const Text('Add Car'),
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
