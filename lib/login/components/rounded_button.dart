import 'package:flutter/material.dart';
import 'package:gp91/components/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  // final Color color;
  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
    // this.color = btnColor,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      // width: size.width * 0.8,
      child:
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(29),
          //   child: TextButton(
          //     onPressed: press,
          //     style: TextButton.styleFrom(
          //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          //       backgroundColor: btnColor,
          //       foregroundColor: Colors.white,
          //     ),
          //     child: Text(
          //       text,
          //       style: const TextStyle(fontSize: 16),
          //     ),

          //   ),
          // ),

          ElevatedButton(
        onPressed: press,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          backgroundColor: btnColor,
          foregroundColor: Colors.black,
          fixedSize: Size(250, 70),
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          elevation: 15,
          shadowColor: btnColor,
          side: BorderSide(color: Colors.black87, width: 2),
          shape: StadiumBorder(),
        ),
      ),
    );
  }
}
