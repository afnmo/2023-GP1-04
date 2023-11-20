import 'package:flutter/material.dart';
import 'package:gp91/components/constants.dart';

class RoundedButtonSmall extends StatelessWidget {
  final String text;
  final VoidCallback press;
  // final Color color;
  const RoundedButtonSmall({
    super.key,
    required this.text,
    required this.press,
    // this.color = btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: btnColor,
          foregroundColor: Colors.black,
          elevation: 15,
          shadowColor: btnColor,
          side: const BorderSide(color: Colors.black87, width: 2),
          shape: const StadiumBorder(),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              inherit: false,
              color: Colors.black),
        ),
      ),
    );
  }
}
