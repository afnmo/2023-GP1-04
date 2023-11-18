import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/consumption/final_entry.dart';
import 'package:gp91/consumption/fuel_firebase.dart';

class FuelPrev extends StatelessWidget {
  const FuelPrev({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: FuelFirebase()
                  .fetchAll(), // Modify this method to fetch all documents
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data![index];
                        var date = data['initialMileage']['date'];
                        var startMileage =
                            data['initialMileage']['startMileage'];
                        var time = data['initialMileage']['time'];

                        return Square(
                          child:
                              'Start Mileage: $startMileage Km \nDate: $date \nTime $time',
                          onTap: () {
                            // Navigate to another page when arrow is tapped
                            Get.to(() => FinalEntry(documentID: data['id']));
                          },
                          // onDelete: () {
                          //   FuelFirebase().deleteDoc(data['id']);
                          // },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Square(
                      child: 'Error: ${snapshot.error}',
                      onTap: () {
                        // Navigate to another page when arrow is tapped
                      },
                      // onDelete: () {},
                    );
                  } else {
                    return Square(
                      child: 'No data available',
                      onTap: () {
                        // Navigate to another page when arrow is tapped
                      },
                      // onDelete: () {},
                    );
                  }
                } else {
                  return Square(
                    child: 'Loading...',
                    onTap: () {
                      // Navigate to another page when arrow is tapped
                    },
                    // onDelete: () {},
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Square extends StatelessWidget {
  final String child;
  final VoidCallback onTap; // Existing onTap callback
  // final VoidCallback onDelete; // New onDelete callback

  const Square({
    super.key,
    required this.child,
    required this.onTap,
  });
// required this.onDelete
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 150,
        color: Colors.deepPurple[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  child,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            InkWell(
              onTap: onTap,
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(Icons.arrow_forward_ios, size: 24),
              ),
            ),
            // InkWell(
            //   onTap: onDelete,
            //   child: const Padding(
            //     padding: EdgeInsets.all(7.0),
            //     child: Icon(Icons.delete, size: 24), // Delete icon
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
