import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../editCarInfoPage/editCarInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'carInfoHandler.dart';

class carInfoBody extends StatelessWidget {
  final String carId;

  carInfoBody({required this.carId});

  Widget editCarButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Define the action you want to perform when the button is pressed
        print("Edit Car Button Clicked");

        // Optionally, you can navigate to another page here.
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => editCarInfo(carId: carId)));
      },
      child: Icon(Icons.edit),
      backgroundColor: Color(0xFFFFCEAF),
    );
  }

  String convertEnglishToArabicNumbers(String input) {
    Map<String, String> numbersMap = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };

    String convertedString = '';
    for (int i = 0; i < input.length; i++) {
      String currentChar = input[i];
      String convertedChar = numbersMap[currentChar] ?? currentChar;
      convertedString += convertedChar;
    }

    return convertedString;
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
    return StreamBuilder<DocumentSnapshot>(
      stream: carInfoHandler.getCarDataStream(carId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          var carData = snapshot.data!.data() as Map<String, dynamic>?;
          Color carColor = parseColor(carData?['color']);
          String? imageFile = carData?['image'];
          List<int> bytes = [];
          if (imageFile != null && imageFile.isNotEmpty) {
            bytes = base64Decode(imageFile);
          }

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
              centerTitle: true,
              title: Text(
                'Car details',
                style: TextStyle(
                  color: Colors.white, // Set the text color
                  fontSize: 20, // Set the text size
                  fontWeight: FontWeight.bold, // Set the font weight
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          width: 380,
                          height: 600,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (imageFile != null && imageFile.isNotEmpty)
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.memory(
                                        Uint8List.fromList(bytes),
                                        height: 160,
                                        width: 300,
                                      ),
                                    )
                                  else
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/myCars.png",
                                        color: carColor,
                                        height: 160,
                                        width: 300,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Make",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C9869),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  carData!['make'] as String? ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        215, 60, 64, 70),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Model",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C9869),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  carData['model'] as String? ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        215, 60, 64, 70),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Year",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C9869),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  carData['year'] as String? ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        215, 60, 64, 70),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Fuel Type",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C9869),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  carData['fuelType']
                                                          as String? ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        215, 60, 64, 70),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Fuel Economy",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C9869),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  carData['fuelEconomy']
                                                          as String? ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        215, 60, 64, 70),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Plate",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C9869),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 146, 158, 145),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                width: 210,
                                                height: 70,
                                                child: Table(
                                                  border: TableBorder.symmetric(
                                                    inside: BorderSide(
                                                      width: 2.0,
                                                      color: Color.fromARGB(
                                                          255, 146, 158, 145),
                                                    ),
                                                  ),
                                                  children: [
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  carData['plateNumbers']
                                                                          as String? ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Color(
                                                                        0xFF81A5A7),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  convertEnglishToArabicNumbers(
                                                                    carData['plateNumbers']
                                                                            as String? ??
                                                                        '',
                                                                  ),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Color(
                                                                        0xFF81A5A7),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Image.asset(
                                                              'assets/images/KSA.png',
                                                              width: 50,
                                                              height: 50,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  (carData['englishLetters']
                                                                              as String?)
                                                                          ?.toUpperCase() ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Color(
                                                                        0xFF81A5A7),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  (carData['arabicLetters']
                                                                              as String?)
                                                                          ?.toUpperCase() ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Color(
                                                                        0xFF81A5A7),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
            ),
            floatingActionButton: editCarButton(context),
          );
        }
      },
    );
  }
}
