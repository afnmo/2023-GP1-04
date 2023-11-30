import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gp91/car/add_car_page/add_car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_info_page/car_info.dart';
import 'car_data_handler.dart';
import 'package:gp91/car/appBarStyle/customShapeBorder.dart';

class CarBody extends StatefulWidget {
  const CarBody({super.key});

  @override
  State<CarBody> createState() => _CarBodyState();
}

class _CarBodyState extends State<CarBody> {
  late Stream<List<String?>> _carsStream;
  CarDataHandler _carDataHandler = CarDataHandler();

  @override
  void initState() {
    super.initState();
    loadCarDocumentIds();
  }

  void loadCarDocumentIds() async {
    _carsStream = CarDataHandler.fetchCarDocumentIdsAsStream();
    setState(() {}); // Trigger a rebuild to reflect changes from the stream
  }

  Widget addCarButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Define the action you want to perform when the button is pressed
        print("Add Car Button Clicked");

        // Optionally, you can navigate to another page here.
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddCar()));
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
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(80),
      //   child: customShapeBorder('Cars'),
      // ),
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
          'Cars',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<String?>>(
        stream: _carsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No cars available yet'),
            );
          } else {
            List<String?> carDocumentIds = snapshot.data!;
            return Padding(
              padding: EdgeInsets.only(top: 15),
              child: ListView.builder(
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
                        String? imageFile = carData['image'];
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
                                      CarInfo(carId: carDocumentId),
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
                                    if (imageFile != null &&
                                        imageFile.isNotEmpty)
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Car Name',
                                                  style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF0C9869),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Text(
                                                    carData['name'],
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          215, 60, 64, 70),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          iconSize: 30,
                                          onPressed: () {
                                            if (carDocumentId != null) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          radius: 15,
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'Confirm Deletion',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Are you sure you want to delete this car?',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.red,
                                                          onPrimary:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                        child: Text('Delete'),
                                                        onPressed: () {
                                                          _carDataHandler
                                                              .deleteCar(
                                                                  carDocumentId);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
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
            );
          }
        },
      ),
      floatingActionButton: addCarButton(context),
    );
  }
}
