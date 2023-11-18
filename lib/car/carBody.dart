import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp91/car/addCarPage/addCar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'carInfo.dart';

class CarBody extends StatefulWidget {
  @override
  State<CarBody> createState() => _CarBodyState();
}

class _CarBodyState extends State<CarBody> {
  late Future<void> _firebaseInitialization;
  late Future<List<String?>> _fetchCarsFuture;
  bool _isFirebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _firebaseInitialization = initializeFirebase();
    _fetchCarsFuture = fetchDocumentIdsByEmail();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      _isFirebaseInitialized = true;
    });
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

  Future<String?> findDocumentIdByEmail() async {
    if (!_isFirebaseInitialized) {
      await initializeFirebase();
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: user?.email).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<List<String?>> fetchDocumentIdsByEmail() async {
    String? userDocId = await findDocumentIdByEmail();

    if (userDocId != null) {
      final carCollection = FirebaseFirestore.instance.collection('Cars');
      QuerySnapshot carQuerySnapshot =
          await carCollection.where('userId', isEqualTo: userDocId).get();

      List<String?> carDocumentIds =
          carQuerySnapshot.docs.map<String?>((carDoc) => carDoc.id).toList();

      return carDocumentIds;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _firebaseInitialization,
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
                                            color: Color(0xFF3C4046),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment(0.7, -0.7),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFECAE),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Text(
                                                  carData['model'],
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
