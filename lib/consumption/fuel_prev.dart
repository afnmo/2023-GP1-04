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
    Size size = MediaQuery.of(context).size;
    // double topImageHeight =
    //     200; // Adjust this value according to your image's height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6EA67C),
        elevation: 4,
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
      body: Stack(
        children: [
          Positioned(
            // top: 0,
            // left: 0,
            // right: 0,
            child: Image.asset(
              "assets/images/bkg_fuel_new2.png",
              width: size.width,
              // height: topImageHeight,
            ),
          ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: Image.asset(
          //     "assets/images/bkg_fuel_bottom.png",
          //     // width: size.width * 2,
          //     // height: 300,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: FutureBuilder<Map<Car, List<ConsumptionRecord>>>(
              future: carConsumptionData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView(
                      children: snapshot.data!.entries.map((entry) {
                        Car car = entry.key;
                        List<ConsumptionRecord> records = entry.value;
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ExpansionTile(
                            leading:
                                Icon(Icons.directions_car, color: Colors.blue),
                            title: Text(
                              car.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6EA67C),
                              ),
                            ),
                            children: records.map((record) {
                              return ListTile(
                                title: Text(
                                  'Start Mileage: ${record.startMileage} Km',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6EA67C),
                                  ),
                                ),
                                subtitle: Text(
                                  'Start Date: ${record.startDate}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios,
                                      color: Colors.blue),
                                  onPressed: () {
                                    var carId = car.carId;
                                    var consumptionId = record.consumptionId;
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
                    return const Center(child: Text('No data available'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onIndexChanged: (index) {
          // Handle index changes
        },
      ),
    );
  }
}
