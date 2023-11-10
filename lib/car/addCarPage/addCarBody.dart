import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'carData.dart';

void main() {
  runApp(
    MaterialApp(
      home: addCarBody(),
    ),
  );
}

// Future<List<String>> readExcelColumn(String columnName) async {
//   final List<String> columnValues = [];
//   final ByteData data =
//       await rootBundle.load('assets/carDataSet/Vehicle Details.xlsx');
//   final bytes = data.buffer.asUint8List();
//   final excel = Excel.decodeBytes(bytes);

//   for (var table in excel.tables.keys) {
//     var sheet = excel.tables[table]!;

//     var columnIndex = -1; // Initialize columnIndex to -1
//     for (var cell in sheet.rows[0]) {
//       if (cell?.value != null && cell?.value == columnName) {
//         columnIndex = sheet.rows[0].indexOf(cell);
//         break;
//       }
//     }

//     if (columnIndex != -1) {
//       // Iterate through rows and extract the specified column data
//       for (var row in sheet.rows) {
//         if (row[0] != null && row[0]!.value == columnName) {
//           // Skip the header row
//           continue;
//         }

//         var cellValue = row[columnIndex]?.value; // Conditional access
//         if (cellValue != null) {
//           columnValues.add(cellValue);
//         }
//       }
//     }
//   }

//   return columnValues;
// }

class addCarBody extends StatefulWidget {
  const addCarBody({Key? key}) : super(key: key);

  @override
  _addCarBodyState createState() => _addCarBodyState();
}

class _addCarBodyState extends State<addCarBody> {
  double fixedWidth = 350.0;
  double fixedHeight = 200.0;
  List<String> years =
      List.generate(100, (index) => (DateTime.now().year - index).toString());
  String? selectedYear; // Make selectedYear nullable with '?'
  List<String> fuelTypes = ['91', '95', 'Diesel'];
  String? selectedFuelType;
  String? selectedCarMake;
  String? selectedCarModel;
  TextEditingController englishLettersController = TextEditingController();
  TextEditingController arabicLettersController = TextEditingController();
  TextEditingController numbersController = TextEditingController();

  Map<String, List<String>> mapOfCarMakeAndModel = carData.getCarData();

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
  }

  void initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  void submitFormData(String userId) {
    // Gather form data
    String make = selectedCarMake ?? '';
    String model = selectedCarModel ?? '';
    String year = selectedYear ?? '';
    String fuelType = selectedFuelType ?? '';
    String englishLetters = englishLettersController.text ?? '';
    String arabicLetters = arabicLettersController.text ?? '';
    String numbers = numbersController.text ?? '';

    // Additional form data variables (plate number, etc.)

    // Check if all required data is available
    if (make.isNotEmpty &&
        model.isNotEmpty &&
        year.isNotEmpty &&
        fuelType.isNotEmpty &&
        englishLetters.isNotEmpty &&
        arabicLetters.isNotEmpty &&
        numbers.isNotEmpty) {
      // Submit data to Firebase
      FirebaseFirestore.instance.collection('Car').add({
        'make': make,
        'model': model,
        'year': year,
        'fuelType': fuelType,
        'englishLetters': englishLetters,
        'arabicLetters': arabicLetters,
        'plateNumbers': numbers,
        'userId': userId,
      });

      // Optionally, you can clear the form fields after submission
      setState(() {
        selectedCarMake = null;
        selectedCarModel = null;
        selectedYear = null;
        selectedFuelType = null;
        englishLettersController
            .clear(); // Use clear() to clear the text in the TextEditingController
        arabicLettersController.clear();
        numbersController.clear();
        // Clear other form fields if needed
      });

      // Optionally, show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Car added successfully to Firebase!'),
      ));
    } else {
      // Handle case where required data is missing
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all required fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget build(BuildContext context) {
    @override
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6EA67C), // Set the background color
        elevation: 0, // Remove the shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Add a new car',
            style: TextStyle(
              color: Colors.white, // Set the text color
              fontSize: 20, // Set the text size
              fontWeight: FontWeight.bold, // Set the font weight
            ),
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
                            // ConstrainedBox(
                            //   constraints: BoxConstraints(maxWidth: fixedWidth),
                            //   child: FutureBuilder<List<String>>(
                            //     future: readExcelColumn('Manufcaturer'),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.connectionState ==
                            //           ConnectionState.waiting) {
                            //         return CircularProgressIndicator(); // Show a loading indicator while data is loading
                            //       } else if (snapshot.hasError) {
                            //         return Text('Error: ${snapshot.error}');
                            //       } else if (!snapshot.hasData ||
                            //           snapshot.data!.isEmpty) {
                            //         return Text('No data available');
                            //       } else {
                            //         return DropdownButtonFormField<String>(
                            //           value:
                            //               selectedMaker, // You can initialize this with the default value if needed
                            //           items: snapshot.data!.map((String value) {
                            //             return DropdownMenuItem<String>(
                            //               value: value,
                            //               child: Text(value),
                            //             );
                            //           }).toList(),
                            //           onChanged: (String? newValue) {
                            //             setState(() {
                            //               selectedMaker = newValue;
                            //             });
                            //           },
                            //           decoration: InputDecoration(
                            //             labelText: 'Make',
                            //             border: OutlineInputBorder(
                            //               borderRadius: BorderRadius.circular(10),
                            //             ),
                            //           ),
                            //         );
                            //       }
                            //     },
                            //   ),
                            // ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: fixedWidth,
                                maxHeight: fixedHeight,
                              ),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return DropdownButtonFormField<String>(
                                    value: selectedCarMake,
                                    items: mapOfCarMakeAndModel.keys
                                        .map((String make) {
                                      return DropdownMenuItem<String>(
                                        value: make,
                                        child: Text(make),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCarMake = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Make',
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
                                            color: Color.fromARGB(255, 255, 187,
                                                145)), // Change the color as needed
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
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return DropdownButtonFormField<String>(
                                    value: selectedCarMake != null
                                        ? selectedCarModel
                                        : null,
                                    items: (mapOfCarMakeAndModel[
                                                selectedCarMake] ??
                                            [])
                                        .map((String model) {
                                      return DropdownMenuItem<String>(
                                        value: model,
                                        child: Text(model),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        if (newValue == selectedCarModel) {
                                          // Clear the selection
                                          selectedCarModel = null;
                                        } else {
                                          selectedCarModel = newValue;
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Model',
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
                                            color: Color.fromARGB(255, 255, 187,
                                                145)), // Change the color as needed
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
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedYear = newValue;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Year',
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
                                        color: Color.fromARGB(255, 255, 187,
                                            145)), // Change the color as needed
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
                                  labelText: 'Fuel Type',
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
                                        color: Color.fromARGB(255, 255, 187,
                                            145)), // Change the color as needed
                                  ),
                                  prefixIcon: Icon(
                                    Icons.local_gas_station,
                                    color: Color(0xFFFFCEAF),
                                  ),
                                ),
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
                                  labelText: 'English letters',
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
                                        color: Color.fromARGB(255, 255, 187,
                                            145)), // Change the color as needed
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
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'^[\u0600-\u06FF\s]*$')), // Allow only Arabic letters
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Arabic letters',
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
                                        color: Color.fromARGB(255, 255, 187,
                                            145)), // Change the color as needed
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
                                  labelText: 'Numbers',
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
                                        color: Color.fromARGB(255, 255, 187,
                                            145)), // Change the color as needed
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
                            ElevatedButton(
                              onPressed: () async {
                                // Check if the user is authenticated
                                User? currentUser =
                                    FirebaseAuth.instance.currentUser;

                                // Check if any field is empty
                                if (selectedCarMake == null ||
                                    selectedCarModel == null ||
                                    selectedYear == null ||
                                    selectedFuelType == null ||
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

                                if (englishLettersController.text.length > 3) {
                                  // Display a message indicating that numbersController should have exactly 3 characters
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'English field should not have more than 3 characters'),
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

                                if (arabicLettersController.text.length > 3) {
                                  // Display a message indicating that numbersController should have exactly 3 characters
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Arabic field should not have more than 3 characters'),
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
                                if (numbersController.text.length != 3) {
                                  // Display a message indicating that numbersController should have exactly 3 characters
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Numbers field should have exactly 3 characters'),
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
                                  submitFormData(currentUser.uid);
                                } else {
                                  // Handle the case where the user is not authenticated
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Please sign in before adding a car.'),
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
                                'Add',
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

// class addCarBody extends StatelessWidget {
//   const addCarBody({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final fixedWidth = 350.0; // Set a fixed width for the form fields
//     List<String> years = List.generate(100, (index) => (DateTime.now().year - index).toString());
//     String selectedYear;

//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Container(
//               width: 700,
//               decoration: BoxDecoration(
//                 color: Color(0xFFFFFBEA),
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 3,
//                     blurRadius: 10,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 19,
//                     ),
//                     Align(
//                       alignment: Alignment(-0.8, 0.8),
//                       child: Text(
//                         'Basic information',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFFFFECAE),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 19,
//                     ),
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: fixedWidth),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Make',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: fixedWidth),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Model',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     ConstrainedBox(
//   constraints: BoxConstraints(maxWidth: fixedWidth),
//   child: DropdownButtonFormField<String>(
//     value: selectedYear,
//     items: years.map((String year) {
//       return DropdownMenuItem<String>(
//         value: year,
//         child: Text(year),
//       );
//     }).toList(),
//     onChanged: (String newValue) {
//       setState(() {
//         selectedYear = newValue;
//       });
//     },
//     decoration: InputDecoration(
//       labelText: 'Year',
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//   ),
// )

//                     SizedBox(
//                       height: 15,
//                     ),
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: fixedWidth),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Fuel type',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 22,
//                     ),
//                     Align(
//                       alignment: Alignment(-0.8, 0.8),
//                       child: Text(
//                         'Plate Number',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFFFFECAE),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 19,
//                     ),
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: fixedWidth),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'English letters',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                       ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: fixedWidth),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'English Numbers',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         primary: Color(
//                             0xFFFFCEAF), // Set the button's background color
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                               10), // Adjust the radius as needed
//                         ),
//                         minimumSize: Size(150, 35),
//                       ),
//                       child: Text(
//                         'Add',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
