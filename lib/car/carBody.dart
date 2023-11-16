import 'package:flutter/material.dart';
import 'package:gp91/car/addCarPage/addCar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class CarBody extends StatelessWidget {
//   void addCar() {
//     // Define the action you want to perform when the button is pressed
//     print("Add Car Button Clicked"); // For example, print a message
//   }

class CarBody extends StatelessWidget {
  Widget addCarButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Define the action you want to perform when the button is pressed
        print("Add Car Button Clicked");

        // Optionally, you can navigate to another page here.
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => addCar()));
      },
      child: Icon(Icons.add),
      backgroundColor: Color(0xFFFFCEAF),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6EA67C), // Set the background color
        elevation: 0, // Remove the shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Cars',
            style: TextStyle(
              color: Colors.white, // Set the text color
              fontSize: 20, // Set the text size
              fontWeight: FontWeight.bold, // Set the font weight
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Remove the commented out AppBarWidget and text

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 9),
                    child: Container(
                      width: 380,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFBEA),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/55.png",
                              height: 80,
                              width: 150,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment(0.7, -0.7),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFECAE),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Chevrolet",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: GestureDetector(
      //   onTap: addCar(),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       color: Color(0xFFFFCEAF),
      //       shape: BoxShape.circle,
      //     ),
      //     child: Image.asset(
      //       "assets/icons/addCar.png",
      //       height: 50,
      //     ),
      //   ),
      // ),
      floatingActionButton: addCarButton(context),
    );
  }
}
