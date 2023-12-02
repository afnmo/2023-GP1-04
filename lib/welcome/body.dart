import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/employee/login.dart';
import 'package:gp91/login/login.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    Size size = MediaQuery.of(context).size;

    // Main container containing the entire body
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Positioned widget for the top background image
          Positioned(
            top: 0,
            child: Image.asset(
              "assets/images/bkg_top.png",
              width: size.width * 1,
            ),
          ),
          // Positioned widget for the logo
          Positioned(
            top: size.height * 0.1,
            child: Image.asset(
              "assets/images/logo_no_bkg.png",
              width: size.width,
              height: size.height * 0.3,
            ),
          ),
          // SingleChildScrollView for scrollable content
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.3),
                // Welcome text
                const Text(
                  "WELCOME TO 91",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                SizedBox(height: size.height * 0.04),
                // Row containing role options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // User role option
                    InkWell(
                      onTap: () {
                        // Navigate to the user login screen
                        Get.to(() => LoginScreen());
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/userNew2.png",
                            width: 100,
                            height: 100,
                            color: Color.fromARGB(255, 196, 151, 5),
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
                    // Employee role option
                    InkWell(
                      onTap: () {
                        // Navigate to the employee login screen
                        Get.to(() => Login_Employee());
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/employeeNew.png",
                            width: 100,
                            height: 100,
                            color: Color.fromARGB(255, 196, 151, 5),
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
