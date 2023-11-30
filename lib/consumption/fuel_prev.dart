// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gp91/components/bottom_nav.dart';
// import 'package:gp91/components/constants.dart';
// import 'package:gp91/consumption/final_entry.dart';
// import 'package:gp91/consumption/fuel_firebase.dart';

// class FuelPrev extends StatelessWidget {
//   final String carDocumentId;
//   const FuelPrev({super.key, required this.carDocumentId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF6EA67C),
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Previous entries',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Text(
//               "Previously entered mileages: ",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: FuelFirebase()
//                   .fetchAllWithDoneFalse(), // Modify this method to fetch all documents
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         var data = snapshot.data![index];
//                         var date = data['startDate'];
//                         var startMileage = data['startMileage'];
//                         var time = data['startTime'];

//                         return Square(
//                           child:
//                               'Start Mileage: $startMileage Km \nStart Date: $date \nStart Time $time',
//                           onTap: () {
//                             // Navigate to another page when arrow is tapped
//                             Get.to(
//                               () => FinalEntry(
//                                 consumptionId: data['id'],
//                                 carDocumentId: carDocumentId,
//                               ),
//                             );
//                           },
//                           // onDelete: () {
//                           //   FuelFirebase().deleteDoc(data['id']);
//                           // },
//                         );
//                       },
//                     );
//                   } else if (snapshot.hasError) {
//                     return Square(
//                       child: 'Error: ${snapshot.error}',
//                       onTap: () {
//                         // Navigate to another page when arrow is tapped
//                       },
//                       // onDelete: () {},
//                     );
//                   } else {
//                     return Square(
//                       child: 'No data available',
//                       onTap: () {
//                         // Navigate to another page when arrow is tapped
//                       },
//                       // onDelete: () {},
//                     );
//                   }
//                 } else {
//                   return Square(
//                     child: 'Loading...',
//                     onTap: () {
//                       // Navigate to another page when arrow is tapped
//                     },
//                     // onDelete: () {},
//                   );
//                 }
//               },
//             ),
//           ),
//           BottomNav(
//             currentIndex: 0, // Set the initial index as needed
//             onIndexChanged: (index) {
//               // Handle index changes if required
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Square extends StatelessWidget {
//   final String child;
//   final VoidCallback onTap;

//   const Square({
//     super.key,
//     required this.child,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Container(
//         height: 120,
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 86, 137, 123),
//           borderRadius: BorderRadius.circular(15), // Rounded corners
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3), // Shadow position
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
//               child: Center(
//                 child: Text(
//                   child,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: onTap,
//               child: const Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 24,
//                   color: Colors.white, // Adjusting icon color
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'package:gp91/consumption/consumption_models.dart';
import 'package:gp91/consumption/final_entry.dart';
import 'package:gp91/consumption/fuel_firebase.dart';

class FuelPrev extends StatefulWidget {
  const FuelPrev({super.key});

  @override
  _FuelPrevState createState() => _FuelPrevState();
}

class _FuelPrevState extends State<FuelPrev> {
  late Future<Map<Car, List<ConsumptionRecord>>> carConsumptionData;

  @override
  void initState() {
    super.initState();
    carConsumptionData =
        FuelFirebase().fetchCarsWithConsumptionDoneFalseRecords();
  }

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
          'Previous Entries',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Map<Car, List<ConsumptionRecord>>>(
        future: carConsumptionData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView(
                children: snapshot.data!.entries.map((entry) {
                  Car car = entry.key;
                  List<ConsumptionRecord> records = entry.value;
                  return Card(
                    child: ExpansionTile(
                      title: Text(car.name), // Assuming Car has a name field
                      children: records.map((record) {
                        return ListTile(
                          title:
                              Text('Start Mileage: ${record.startMileage} Km'),
                          subtitle: Text('Start Date: ${record.startDate}'),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                color: Colors.blue), // Arrow icon
                            onPressed: () {
                              var carId = car.carId;
                              print("carID: ${carId}");
                              var consumptionId = record.consumptionId;
                              print("consumptionId: ${consumptionId}");
                              Get.to(
                                () => FinalEntry(
                                  consumptionId: consumptionId!,
                                  carDocumentId: carId,
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: Text('No data available'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0, // Set the initial index as needed
        onIndexChanged: (index) {
          // Handle index changes if required
        },
      ),
    );
  }
}
