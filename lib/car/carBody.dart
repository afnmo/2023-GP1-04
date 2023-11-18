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

  @override
  void initState() {
    super.initState();
    _firebaseInitialization = initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final currentUser = FirebaseAuth.instance.currentUser;
          final carCollection = FirebaseFirestore.instance.collection('Cars');
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
            body: StreamBuilder<QuerySnapshot>(
              stream: carCollection
                  .where('userId', isEqualTo: currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot car = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to carInfo page with the ID of the selected car document
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => carInfo(carId: car.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        child: SizedBox(
                          width: 380,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 13),
                            height: 130,
                            // Your container and UI for displaying car details
                            // Example: Displaying car model
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
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          car['model'],
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
                  },
                );
              },
            ),
            floatingActionButton: addCarButton(context),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
