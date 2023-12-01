import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gp91/consumption/fuel_entry.dart';
import 'add_car_page/add_car.dart';
import 'car_info_page/car_info.dart';
import 'car_data_handler.dart';
import 'appBarStyle/customShapeBorder.dart';

class CarBody extends StatefulWidget {
  final bool isConsumption;
  const CarBody({super.key, required this.isConsumption});

  @override
  State<CarBody> createState() => _CarBodyState();
}

class _CarBodyState extends State<CarBody> {
  late final Stream<List<String?>> _carsStream =
      CarDataHandler.fetchCarDocumentIdsAsStream();
  final CarDataHandler _carDataHandler = CarDataHandler();

  @override
  void initState() {
    super.initState();
  }

  Widget addCarButton(BuildContext context) => FloatingActionButton(
        onPressed: () => Get.to(() => AddCar()),
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => AddCar())),
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFFCEAF),
      );

  Color parseColor(String? colorName) {
    const colorMap = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'teal': Colors.teal,
      'cyan': Colors.cyan,
      'amber': Colors.amber,
      'indigo': Colors.indigo,
      'lime': Colors.lime,
      'brown': Colors.brown,
      'grey': Colors.grey,
      'black': Colors.black,
      'white': Colors.white,
      // add other color mappings here if needed
    };

    return colorMap[colorName?.toLowerCase()] ??
        Colors.black; // Default color if not found or colorName is null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder<List<String?>>(
        stream: _carsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cars available yet'));
          } else {
            return buildCarList(snapshot.data!);
          }
        },
      ),
      floatingActionButton: widget.isConsumption ? null : addCarButton(context),
    );
  }

  AppBar buildAppBar() => AppBar(
        backgroundColor: const Color(0xFF6EA67C), // Custom color for AppBar
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back button
        ),
        centerTitle: true,
        title: const Text(
          'Cars',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );

  Widget buildCarList(List<String?> carDocumentIds) {
    return Column(
      children: [
        if (widget.isConsumption)
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Select the car you want to calculate its fuel consumption:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: carDocumentIds.length,
            itemBuilder: (context, index) {
              final carDocumentId = carDocumentIds[index];
              return carDocumentId == null
                  ? const SizedBox()
                  : buildCarItem(context, carDocumentId);
            },
          ),
        ),
      ],
    );
  }

  Widget buildCarItem(BuildContext context, String carDocumentId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('Cars')
          .doc(carDocumentId)
          .get(),
      builder: (context, carSnapshot) {
        if (!carSnapshot.hasData || carSnapshot.data == null) {
          return const SizedBox();
        }

        final carData = carSnapshot.data!.data() as Map<String, dynamic>;
        final carColor = parseColor(carData['color']);
        final imageFile = carData['image'] as String?;
        final bytes = imageFile != null && imageFile.isNotEmpty
            ? base64Decode(imageFile)
            : null;

        return GestureDetector(
          onTap: () => widget.isConsumption
              ? Get.to(() => FuelEntry(carDocumentId: carDocumentId))
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => FuelEntry(carDocumentId: carDocumentId)))
              : Get.to(() => CarInfo(carId: carDocumentId)),
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => CarInfo(carId: carDocumentId))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child:
                buildCarCard(carColor, bytes, carData, carDocumentId, context),
          ),
        );
      },
    );
  }

  Widget buildCarCard(
      Color carColor,
      Uint8List? bytes,
      Map<String, dynamic> carData,
      String carDocumentId,
      BuildContext context) {
    return SizedBox(
      width: 380,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 13),
        height: 130,
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              119, 129, 218, 151), // Custom color for the card background
          borderRadius:
              BorderRadius.circular(22), // Rounded corners for the card
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3))
          ], // Shadow effect
        ),
        child: Row(
          children: [
            buildCarImage(bytes, carColor), // Car image section
            Expanded(child: buildCarDetails(carData)), // Car details section
            if (!widget.isConsumption)
              buildDeleteButton(
                  carDocumentId, context), // Delete button for car management
          ],
        ),
      ),
    );
  }

  Widget buildCarImage(Uint8List? bytes, Color carColor) {
    return Container(
      child: bytes != null
          ? Image.memory(bytes, height: 200, width: 200)
          : Image.asset("assets/images/myCars.png",
              color: carColor, height: 200, width: 200),
    );
  }

  Widget buildCarDetails(Map<String, dynamic> carData) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Car Name',
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C9869)),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              carData['name'],
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(215, 60, 64, 70)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeleteButton(String carDocumentId, BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      iconSize: 30,
      onPressed: () => showDeleteDialog(carDocumentId, context),
    );
  }

  void showDeleteDialog(String carDocumentId, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: buildDeleteDialogTitle(),
          content: const Text(
            'Are you sure you want to delete this car? \n\n'
            'Please note that all related data will be permanently removed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Get.back(),
              // Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text('Delete'),
              onPressed: () {
                _carDataHandler.deleteCar(carDocumentId);
                Get.back();
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Row buildDeleteDialogTitle() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            backgroundColor: Colors.red,
            radius: 15,
            child: Icon(Icons.delete, color: Colors.white, size: 20)),
        SizedBox(width: 10),
        Text('Confirm Deletion',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20)),
      ],
    );
  }
}
