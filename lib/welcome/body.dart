import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/employee/login.dart';

import 'package:gp91/login/login.dart';

//import 'package:gp91/signup/signup.dart';
//import 'package:gp91/signup_employee/signup_employee.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Image.asset(
              "assets/images/bkg_top.png",
              width: size.width * 1,
            ),
          ),
          Positioned(
            top: size.height * 0.1,
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
                    // Adjust the color as needed
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                const Text(
                  "Choose Your Role",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.bold,
                    // Adjust the color as needed
                    color: Color(0xFFFFCEAF),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigate to the desired screen
                        Get.to(() => LoginScreen());
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/user.png",
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'User',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 75),
                    InkWell(
                      onTap: () {
                        // Navigate to the desired screen
                        Get.to(() => LoginScreen_E());
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/station.png",
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Employee',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
