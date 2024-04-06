import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gp91/car/qr_car/QR.dart';
import '../edit_car_info_page/edit_car_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_info_handler.dart';

class CarInfoBody extends StatelessWidget {
  final String carId;

  CarInfoBody({super.key, required this.carId});

// edit car button
  Widget editCarButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          print("Edit Car Button Clicked");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditCarInfo(carId: carId)));
        },
        child: Icon(Icons.edit),
        backgroundColor: Color.fromARGB(255, 2, 84, 2));
  }

  // QR button
  Widget QrButton(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        print("QR Button Clicked");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => QR(carId: carId)));
      },
      elevation: 0, // No elevation
      fillColor: Colors.transparent, // Transparent background color
      padding: EdgeInsets.zero, // No padding
      shape: CircleBorder(), // Circular shape
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/QR.gif'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

// convert english numbers to arabic numbers
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

// convert color
  Color parseColor(String? colorName) {
    if (colorName != null) {
      switch (colorName) {
        case 'Red':
          return Colors.red;
        case 'Blue':
          return Colors.blue;
        case 'Green':
          return Colors.green;
        case 'Yellow':
          return Colors.yellow;
        case 'Orange':
          return Colors.orange;
        case 'Purple':
          return Colors.purple;
        case 'Pink':
          return Colors.pink;
        case 'Teal':
          return Colors.teal;
        case 'Cyan':
          return Colors.cyan;
        case 'Amber':
          return Colors.amber;
        case 'Indigo':
          return Colors.indigo;
        case 'Lime':
          return Colors.lime;
        case 'Brown':
          return Colors.brown;
        case 'Grey':
          return Colors.grey;
        case 'Black':
          return Colors.black;
        case 'White':
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
      stream: CarInfoHandler.getCarDataStream(carId),
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
            backgroundColor: Color.fromARGB(121, 218, 214, 214),
// app bar style
            appBar: AppBar(
              backgroundColor: Color(0xFF6EA67C),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: const Text(
                'Car details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Stack(
              children: [
                if (imageFile != null && imageFile.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.memory(
                        Uint8List.fromList(bytes),
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: 220,
                      ),
                    ),
                  )
                else
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/myCars.png",
                        fit: BoxFit.cover,
                        color: carColor,
                        width: double.maxFinite,
                        height: 220,
                      ),
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 230,
                  child: Container(
                    height: 600,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      color: Color.fromARGB(119, 129, 218, 151),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 70,
                              ),
                              Text(
                                'Basic information',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0C9869),
                                ),
                              ),
                              Spacer(), // Add Spacer to push QR button to the right
                              QrButton(context),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: Colors.black,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Make:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                carData!['make'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: Colors.black,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Model:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                carData['model'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.black,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Year:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                carData['year'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.local_gas_station,
                                color: Colors.black,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Fuel Type:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                carData['fuelType'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.local_gas_station,
                                color: Colors.black,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Fuel Economy:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                carData['fuelEconomy'] + ' MPG' as String? ??
                                    '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 70,
                              ),
                              Text(
                                'Plate information',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0C9869),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(150, 0, 0, 0),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                width: 210,
                                height: 70,
                                child: Table(
                                  border: TableBorder.symmetric(
                                    inside: BorderSide(
                                      width: 2.0,
                                      color: const Color.fromARGB(150, 0, 0, 0),
                                    ),
                                  ),
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  carData['plateNumbers']
                                                          as String? ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  convertEnglishToArabicNumbers(
                                                    carData['plateNumbers']
                                                            as String? ??
                                                        '',
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'assets/images/KSA.png',
                                              width: 30,
                                              height: 40,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  (carData['englishLetters']
                                                              as String?)
                                                          ?.toUpperCase() ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  (carData['arabicLetters']
                                                              as String?)
                                                          ?.toUpperCase() ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: editCarButton(context),
          );
        }
      },
    );
  }
}
