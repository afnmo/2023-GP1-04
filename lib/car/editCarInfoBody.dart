import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:gp91/car/addCarPage/carData.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'carInfo.dart';

class editCarInfoBody extends StatefulWidget {
  final String carId;

  const editCarInfoBody({Key? key, required this.carId}) : super(key: key);

  @override
  _editCarInfoBodyState createState() => _editCarInfoBodyState();
}

class _editCarInfoBodyState extends State<editCarInfoBody> {
  double fixedWidth = 350.0;
  double fixedHeight = 200.0;

  List<List<dynamic>> _carData = [];
  List<String> _uniqueManufacturers = [];
  List<String> carModels = [];
  List<String> FuelEconomys = [];
  List<String> years = [];

  late Map<String, dynamic> carDataInfo = {};
  String? selectedYear;
  List<String> fuelTypes = ['91', '95', 'Diesel'];
  String? selectedFuelType;
  String? selectedFuelEconomy;
  String? selectedCarMake;
  String? selectedCarModel;
  TextEditingController englishLettersController = TextEditingController();
  TextEditingController arabicLettersController = TextEditingController();
  TextEditingController numbersController = TextEditingController();
  carData carDataObj = carData();

  @override
  void dispose() {
    englishLettersController.dispose();
    arabicLettersController.dispose();
    numbersController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    loadCSV();
    extractManufacturers();
    getCarData();
  }

  Future<void> getCarData() async {
    DocumentSnapshot carDoc = await FirebaseFirestore.instance
        .collection('Cars')
        .doc(widget.carId)
        .get();

    carDataInfo = carDoc.data() as Map<String, dynamic>;

    if (carDataInfo['make'] != null) {
      selectedCarMake = carDataInfo['make'];
    }

    if (carDataInfo['fuelType'] != null) {
      selectedFuelType = carDataInfo['fuelType'];
    }

    if (carDataInfo['model'] != null) {
      selectedCarModel = carDataInfo['model'];
    }

    if (carDataInfo['year'] != null) {
      selectedYear = carDataInfo['year'];
    }

    if (carDataInfo['fuelEconomy'] != null) {
      selectedFuelEconomy = carDataInfo['fuelEconomy'];
    }

    if (carDataInfo['englishLetters'] != null) {
      englishLettersController =
          TextEditingController(text: carDataInfo['englishLetters']);
    }

    if (carDataInfo['arabicLetters'] != null) {
      arabicLettersController =
          TextEditingController(text: carDataInfo['arabicLetters']);
    }

    if (carDataInfo['plateNumbers'] != null) {
      numbersController =
          TextEditingController(text: carDataInfo['plateNumbers']);
    }
  }

  void initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  void loadCSV() async {
    List<List<dynamic>> csvData = await carData.loadCSVData();
    setState(() {
      _carData = csvData;
    });
  }

  void extractManufacturers() async {
    List<String> manufacturers = await carData.extractManufacturers();
    setState(() {
      _uniqueManufacturers = manufacturers;
    });
  }

// Function to fetch car models based on the selected car make
  Future<void> fetchCarModels(String make) async {
    List<String> models = await carDataObj.getVehicleModels(make);
    setState(() {
      carModels = models;
    });
  }

  Future<void> fetchYears(String make, String model) async {
    List<String> models = await carDataObj.getYearsForMakeAndModel(make, model);
    setState(() {
      years = models;
    });
  }

  Future<void> fetchFuelEconomy(String year, String make, String model) async {
    List<String> Economys = await carDataObj.getFuelEconomy(year, make, model);
    setState(() {
      FuelEconomys = Economys;
    });
  }

  Future<void> submitFormData() async {
    // Gather form data
    String make = selectedCarMake ?? '';
    String model = selectedCarModel ?? '';
    String year = selectedYear ?? '';
    String fuelType = selectedFuelType ?? '';
    String fuelEconomy = selectedFuelEconomy ?? '';
    String englishLetters = englishLettersController.text ?? '';
    String arabicLetters = arabicLettersController.text ?? '';
    String numbers = numbersController.text ?? '';
    String grade =
        await carDataObj.getGradeForFuelEconomy(year, make, model, fuelEconomy);

    // Submit data to Firebase
    FirebaseFirestore.instance.collection('Cars').doc(widget.carId).update({
      'make': make,
      'model': model,
      'year': year,
      'fuelType': fuelType,
      'fuelEconomy': fuelEconomy,
      'englishLetters': englishLetters,
      'arabicLetters': arabicLetters,
      'plateNumbers': numbers,
      'grade': grade,
    });

    // Optionally, show a success message or navigate to another screen
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Car added successfully to Firebase!'),
    ));
  }

  Widget build(BuildContext context) {
    @override
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

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
          'Update your car',
          style: TextStyle(
            color: Colors.white, // Set the text color
            fontSize: 20, // Set the text size
            fontWeight: FontWeight.bold, // Set the font weight
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: w,
            height: h * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/addCar3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 700,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFBEA),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Form(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 19,
                            ),
                            Align(
                              alignment: Alignment(-0.8, 0.8),
                              child: Text(
                                'Basic information',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFECAE),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 19,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: fixedWidth,
                              ),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return DropdownButtonFormField<String>(
                                    value: selectedCarMake,
                                    items:
                                        _uniqueManufacturers.map((String make) {
                                      return DropdownMenuItem<String>(
                                        value: make,
                                        child: SizedBox(
                                          width: 120.0,
                                          child: Text(
                                            make,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) async {
                                      setState(() {
                                        selectedCarMake = newValue;
                                        selectedCarModel = null;
                                        selectedYear = null;
                                        selectedFuelEconomy = null;
                                      });
                                      await fetchCarModels(selectedCarMake!);
                                    },
                                    decoration: InputDecoration(
                                      labelText: selectedCarMake ?? 'Make',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.directions_car,
                                        color: Color(0xFFFFCEAF),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: fixedWidth,
                              ),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return DropdownButtonFormField<String>(
                                    value: selectedCarModel,
                                    items: carModels.map((String model) {
                                      return DropdownMenuItem<String>(
                                        value: model,
                                        child: SizedBox(
                                          width: 120.0,
                                          child: Text(
                                            model,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) async {
                                      setState(() {
                                        selectedCarModel = newValue;
                                      });
                                      fetchYears(
                                          selectedCarMake!, selectedCarModel!);
                                    },
                                    decoration: InputDecoration(
                                      labelText: selectedCarModel ?? 'Model',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.directions_car,
                                        color: Color(0xFFFFCEAF),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: fixedWidth, maxHeight: fixedHeight),
                              child: DropdownButtonFormField<String>(
                                value: selectedYear,
                                items: years.map((String year) {
                                  return DropdownMenuItem<String>(
                                    value: year,
                                    child: Text(year),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    selectedYear = newValue;
                                  });
                                  fetchFuelEconomy(selectedYear!,
                                      selectedCarMake!, selectedCarModel!);
                                },
                                decoration: InputDecoration(
                                  labelText: selectedYear ?? 'Year',
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .black, // Change the label text color as needed
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Change the color as needed
                                  ),
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                    color: Color(0xFFFFCEAF),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: fixedWidth, maxHeight: fixedHeight),
                              child: DropdownButtonFormField<String>(
                                value: selectedFuelType,
                                items: fuelTypes.map((String fuelType) {
                                  return DropdownMenuItem<String>(
                                    value: fuelType,
                                    child: Text(fuelType),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedFuelType = newValue;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: selectedFuelType ?? 'Fuel Type',
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .black, // Change the label text color as needed
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Change the color as needed
                                  ),
                                  prefixIcon: Icon(
                                    Icons.local_gas_station,
                                    color: Color(0xFFFFCEAF),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: fixedWidth,
                              ),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return DropdownButtonFormField<String>(
                                    value: selectedFuelEconomy,
                                    items:
                                        FuelEconomys.map((String FuelEconomy) {
                                      return DropdownMenuItem<String>(
                                        value: FuelEconomy,
                                        child: SizedBox(
                                          width: 120.0,
                                          child: Text(
                                            FuelEconomy,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) async {
                                      setState(() {
                                        selectedFuelEconomy = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText:
                                          selectedFuelEconomy ?? 'Fuel Economy',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.local_gas_station,
                                        color: Color(0xFFFFCEAF),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Align(
                              alignment: Alignment(-0.8, 0.8),
                              child: Text(
                                'Plate Number',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFECAE),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 19,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: fixedWidth, maxHeight: fixedHeight),
                              child: TextFormField(
                                controller: englishLettersController,
                                //maxLength: 3,
                                keyboardType: TextInputType
                                    .text, // Use TextInputType.text for English letters
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'^[a-zA-Z]*$')), // Allow only English letters
                                ],
                                decoration: InputDecoration(
                                  labelText: englishLettersController.text ??
                                      'English letters',
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .black, // Change the label text color as needed
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Change the color as needed
                                  ),
                                  prefixIcon: Icon(
                                    Icons.text_fields,
                                    color: Color(0xFFFFCEAF),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: fixedWidth, maxHeight: fixedHeight),
                              child: TextFormField(
                                controller: arabicLettersController,
                                //maxLength: 3,
                                keyboardType: TextInputType
                                    .text, // Use TextInputType.text for Arabic letters
                                // inputFormatters: <TextInputFormatter>[
                                //   FilteringTextInputFormatter.allow(RegExp(
                                //       r'^[\u0600-\u06FF\s]*$')), // Allow only Arabic letters
                                // ],
                                decoration: InputDecoration(
                                  labelText: arabicLettersController.text ??
                                      'Arabic letters',
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .black, // Change the label text color as needed
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Change the color as needed
                                  ),
                                  prefixIcon: Icon(
                                    Icons.text_fields,
                                    color: Color(0xFFFFCEAF),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: fixedWidth, maxHeight: fixedHeight),
                              child: TextFormField(
                                controller: numbersController,
                                //maxLength: 3,
                                keyboardType: TextInputType
                                    .number, // Set the keyboard type to numeric
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter
                                      .digitsOnly // Allow only numeric input
                                ],
                                decoration: InputDecoration(
                                  labelText:
                                      numbersController.text ?? 'Numbers',
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .black, // Change the label text color as needed
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Change the color as needed
                                  ),
                                  prefixIcon: Image.asset(
                                    'assets/icons/numbers.png',
                                    color: Color(0xFFFFCEAF),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Check if the user is authenticated
                                User? currentUser =
                                    FirebaseAuth.instance.currentUser;

                                //Check if any field is empty
                                if (selectedCarMake == null ||
                                    selectedCarModel == null ||
                                    selectedYear == null ||
                                    selectedFuelType == null ||
                                    selectedFuelEconomy == null ||
                                    englishLettersController.text.isEmpty ||
                                    arabicLettersController.text.isEmpty ||
                                    numbersController.text.isEmpty) {
                                  // Display a message indicating that all fields are required
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please fill in all required fields'),
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 99, 88),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  );
                                  return; // Exit the function if any field is empty
                                }

                                if (englishLettersController.text.length != 3) {
                                  // Display a message indicating that numbersController should have exactly 3 characters
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please ensure the English field has exactly 3 characters'),
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 99, 88),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (arabicLettersController.text.length != 3) {
                                  // Display a message indicating that numbersController should have exactly 3 characters
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please ensure the Arabic field has exactly 3 characters'),
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 99, 88),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Check if numbersController has exactly 3 characters
                                if (numbersController.text.length > 4) {
                                  // Display a message indicating that numbersController should have exactly 3 characters
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please enter up to 4 digits in the Numbers field'),
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 99, 88),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (currentUser != null) {
                                  await submitFormData();

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            carInfo(carId: widget.carId)),
                                  );
                                } else {
                                  // Handle the case where the user is not authenticated
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Please sign in before edit your car'),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(
                                    0xFFFFCEAF), // Set the button's background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the radius as needed
                                ),
                                minimumSize: Size(150, 35),
                              ),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}