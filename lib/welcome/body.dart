import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gp91/components/background.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/login/login.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:gp91/signup/signup.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // provides us the total height and weight of our screen
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            // left: 0,
            child: Image.asset(
              "assets/images/bkg_top.png",
              width: size.width * 1,
            ),
          ),
          Positioned(
            top: size.height * 0.1, // Adjust the position as needed
            child: Image.asset(
              "assets/images/logo_no_bkg.png",
              width: size.width,
              height: size.height * 0.3,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.3),
                const Text(
                  "WELCOME TO 91",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(height: size.height * 0.08),
                // Image.asset(
                //   "assets/images/logo_no_bkg.png",
                //   width: size.width,
                //   height: size.height * 0.3,
                // ),
                RoundedButton(
                  text: "LOGIN",
                  press: () {
                    Get.to(() => LoginScreen());
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return LoginScreen();
                    //     },
                    //   ),
                    // );
                  },
                ),
                RoundedButton(
                  text: "SIGN UP",
                  press: () {
                    Get.to(() => SignUpScreen());
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return SignUpScreen();
                    //     },
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
