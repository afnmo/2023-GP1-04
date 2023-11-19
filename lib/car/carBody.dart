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
  late Future<List<String?>> _fetchCarsFuture;

  @override
  void initState() {
    super.initState();
    _fetchCarsFuture = carDataHandler.fetchDocumentIdsByEmail();
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
    return FutureBuilder<void>(
      future: _fetchCarsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder<List<String?>>(
            future: _fetchCarsFuture,
            builder: (context, idsSnapshot) {
              if (idsSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (idsSnapshot.hasData && idsSnapshot.data != null) {
                List<String?> carDocumentIds = idsSnapshot.data!;
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Color(0xFF6EA67C), // Set the background color
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
                          if (carSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (carSnapshot.hasData && carSnapshot.data != null) {
                            Map<String, dynamic> carData = carSnapshot.data!
                                .data() as Map<String, dynamic>;
                            Color carColor = parseColor(carData['color']);
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 13),
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
                                            "assets/images/myCars.png",
                                            height: 80,
                                            width: 150,
                                            color: carColor,
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
                                                padding:
                                                    const EdgeInsets.all(6.0),
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
              } else {
                return Center(
                    //child: Text('No cars found.'),
                    );
              }
            },
          );
        }
        return Center(
            //child:
            //  CircularProgressIndicator(),
            );
      },
    );
  }
}
