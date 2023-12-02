import 'package:flutter/material.dart';

// Custom background widget with images and a child widget
class Background extends StatelessWidget {
  // Child widget to be displayed on the background
  final Widget child;

  // Constructor to initialize the background with a child
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen size using MediaQuery
    Size size = MediaQuery.of(context).size;

    // Return a container with a stack containing background images and the child
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: <Widget>[
          // Positioned image at the top-left corner
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/top_e.png",
              width: size.width * 0.35,
            ),
          ),
          // Positioned image at the bottom-right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/down_e.png",
              width: size.width * 0.35,
            ),
          ),
          // Child widget to be displayed in the center
          child,
          // Positioned back button at the top-left corner
          const Positioned(
            top: 30,
            left: 30,
            child: BackButton(),
          ),
        ],
      ),
    );
  }
}
