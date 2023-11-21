import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp91/car/addCarPage/addCar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'carInfoPage/carInfo.dart';
import 'carDataHandler.dart';

class CarBody extends StatefulWidget {
  @override
  State<CarBody> createState() => _CarBodyState();
}

class _CarBodyState extends State<CarBody> {
  late Stream<List<String?>> _carsStream;

  @override
  void initState() {
    super.initState();
    loadCarDocumentIds();
  }

  void loadCarDocumentIds() async {
    _carsStream = carDataHandler.fetchCarDocumentIdsAsStream();
    setState(() {}); // Trigger a rebuild to reflect changes from the stream
  }

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

  Color parseColor(String? colorName) {
    if (colorName != null) {
      switch (colorName.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'blue':
          return Colors.blue;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        case 'orange':
          return Colors.orange;
        case 'purple':
          return Colors.purple;
        case 'pink':
          return Colors.pink;
        case 'teal':
          return Colors.teal;
        case 'cyan':
          return Colors.cyan;
        case 'amber':
          return Colors.amber;
        case 'indigo':
          return Colors.indigo;
        case 'lime':
          return Colors.lime;
        case 'brown':
          return Colors.brown;
        case 'grey':
          return Colors.grey;
        case 'black':
          return Colors.black;
        case 'white':
          return Colors.white;
        default:
          return Colors.black; // Default color if not found
      }
    }
    return Colors.black; // Default color if colorName is null
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String?>>(
      stream: _carsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<String?> carDocumentIds = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF6EA67C), // Set the background color
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Handle back button press
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: Text(
                'Cars',
                style: TextStyle(
                  color: Colors.white, // Set the text color
                  fontSize: 20, // Set the text size
                  fontWeight: FontWeight.bold, // Set the font weight
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: carDocumentIds.length,
              itemBuilder: (context, index) {
                String? carDocumentId = carDocumentIds[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Cars')
                      .doc(carDocumentId)
                      .get(),
                  builder: (context, carSnapshot) {
                    if (carSnapshot.hasData && carSnapshot.data != null) {
                      Map<String, dynamic> carData =
                          carSnapshot.data!.data() as Map<String, dynamic>;
                      Color carColor = parseColor(carData['color']);
                      String? imageFile = carData?['image'];
                      List<int> bytes = [];
                      if (imageFile != null && imageFile.isNotEmpty) {
                        bytes = base64Decode(imageFile);
                      }
                      return GestureDetector(
                        onTap: () {
                          if (carDocumentId != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    carInfo(carId: carDocumentId),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 9),
                          child: SizedBox(
                            width: 380,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 13),
                              height: 130,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(119, 129, 218, 151),
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
                                  if (imageFile != null && imageFile.isNotEmpty)
                                    Container(
                                      // alignment: Alignment.center,
                                      child: Image.memory(
                                        Uint8List.fromList(bytes),
                                        height: 200,
                                        width: 200,
                                      ),
                                    )
                                  else
                                    Container(
                                      //alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/myCars.png",
                                        color: carColor,
                                        height: 200,
                                        width: 200,
                                      ),
                                    ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment(0.7, -0.7),
                                      child: Container(
                                        // decoration: BoxDecoration(
                                        //   color: Color(0xFFFFECAE),
                                        //   borderRadius:
                                        //       BorderRadius.circular(15),
                                        // ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            carData['name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0C9869),
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
                        ),
                      );
                    } else {
                      return SizedBox(); // Placeholder if data isn't available
                    }
                  },
                );
              },
            ),
            floatingActionButton: addCarButton(context),
          );
        }
      },
    );
  }
}
