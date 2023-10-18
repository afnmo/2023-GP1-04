import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 30,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Handle back button press, e.g., navigate to the previous screen or pop the current screen.
          // Navigator.of(context).pop();
          Get.back();
        },
        iconSize: 50,
        tooltip: 'Go back',
        hoverColor: Colors.yellow,
      ),
    );
  }
}
