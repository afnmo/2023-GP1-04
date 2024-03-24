import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp91/bill/TimeLineTileUI.dart';
import 'package:gp91/components/bottom_nav.dart';

class ScreenBill extends StatefulWidget {
  const ScreenBill({Key? key}) : super(key: key);

  @override
  State<ScreenBill> createState() => _HomeScreenState();
}

Stream<List<DocumentSnapshot>> fetchBillsAsStream() async* {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('Users');

      QuerySnapshot querySnapshot = await usersCollection
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userDocId = querySnapshot.docs.first.id;

        final billCollection = FirebaseFirestore.instance.collection('Bills');
        Stream<QuerySnapshot> billQueryStream =
            billCollection.where('userId', isEqualTo: userDocId).snapshots();

        await for (QuerySnapshot billSnapshot in billQueryStream) {
          yield billSnapshot.docs;
        }
      }
    }
  } catch (e) {
    print('Error fetching bills: $e');
    yield [];
  }
}

Future<DocumentSnapshot?> fetchCarDetails(String carId) async {
  try {
    return await FirebaseFirestore.instance.collection('Cars').doc(carId).get();
  } catch (e) {
    print('Error fetching car details: $e');
    return null;
  }
}

class _HomeScreenState extends State<ScreenBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBE3D5),
      appBar: AppBar(
        // App bar styling
        backgroundColor: Color(0xFF6EA67C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Bills',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: fetchBillsAsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No bills found for the user.');
            } else {
              List<DocumentSnapshot> billDocs = snapshot.data!;
              bool allStationsNull = true;

              for (var billDoc in billDocs) {
                var billData = billDoc.data() as Map<String, dynamic>;
                if (billData['stationName'] != null) {
                  allStationsNull = false;
                  break;
                }
              }

              if (allStationsNull) {
                return Text('No bills found for the userdd.');
              } else {
                return ListView.builder(
                  itemCount: billDocs.length,
                  itemBuilder: (context, index) {
                    var billData =
                        billDocs[index].data() as Map<String, dynamic>;
                    if (billData['stationName'] != null)
                      return FutureBuilder<DocumentSnapshot?>(
                        future: fetchCarDetails(billData['carId']),
                        builder: (context, carSnapshot) {
                          if (carSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (carSnapshot.hasError) {
                            return Text(
                                'Error fetching car details: ${carSnapshot.error}');
                          } else if (!carSnapshot.hasData ||
                              carSnapshot.data == null) {
                            return Text('Car details not found');
                          } else {
                            var carData = carSnapshot.data!.data()
                                as Map<String, dynamic>;
                            return TimeLineTileUI(
                              isFirst: index == 0,
                              isLast: index == billDocs.length - 1,
                              isPast: true,
                              eventChild: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.date_range_outlined,
                                          color: Colors.white),
                                      SizedBox(width: 15.0),
                                      Text(
                                        ' ${billData['date']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Amount: ${billData['amount']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Station: ${billData['stationName']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Car Name: ${carData['name']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  // Display other fields as needed
                                ],
                              ),
                            );
                          }
                        },
                      );
                  },
                );
              }
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 4, // Set the initial index as needed
        onIndexChanged: (index) {
          // Handle index changes if required
        },
      ),
    );
  }
}
