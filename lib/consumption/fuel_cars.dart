import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/consumption/fuel_entry.dart';
import 'package:gp91/consumption/fuel_firebase.dart';

class FuelCars extends StatelessWidget {
  const FuelCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Select the car you want to calculate its fuel consumption:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<String?>>(
              future: FuelFirebase().fetchDocumentIdsByEmail(),
              builder: (context, idsSnapshot) {
                if (idsSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (idsSnapshot.hasData && idsSnapshot.data != null) {
                  List<String?> carDocumentIds = idsSnapshot.data!;
                  return Scaffold(
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
                              return const CircularProgressIndicator();
                            }
                            if (carSnapshot.hasData &&
                                carSnapshot.data != null) {
                              Map<String, dynamic> carData = carSnapshot.data!
                                  .data() as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  if (carDocumentId != null) {
                                    Get.to(() => FuelEntry(
                                        carDocumentId: carDocumentId));
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 9),
                                  child: SizedBox(
                                    width: 380,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 13),
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 198, 197, 151),
                                        borderRadius: BorderRadius.circular(22),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 3,
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              "assets/images/myCars.png",
                                              height: 120,
                                              width: 170,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment:
                                                  const Alignment(0.7, -0.7),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 67, 116, 87),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Text(
                                                    carData['model'],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              return const SizedBox();
                            }
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No cars found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
