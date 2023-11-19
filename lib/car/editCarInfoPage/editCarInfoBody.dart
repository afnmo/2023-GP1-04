import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../carInfoPage/carInfo.dart';
import 'editCarInfoHandler.dart';

class editCarInfoBody extends StatefulWidget {
  final String carId;

  const editCarInfoBody({Key? key, required this.carId}) : super(key: key);

  @override
  _editCarInfoBodyState createState() => _editCarInfoBodyState();
}

class _editCarInfoBodyState extends State<editCarInfoBody> {
  double fixedWidth = 350.0;
  double fixedHeight = 200.0;

  late Map<String, dynamic> carDataInfo = {};
  List<String> fuelTypes = ['91', '95', 'Diesel'];
  String? selectedFuelType;
  TextEditingController englishLettersController = TextEditingController();
  TextEditingController numbersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCarData();
  }

  void updataFormData() async {
    // Check if any field is empty
    if (selectedFuelType == null ||
            englishLettersController.text.isEmpty ||
            numbersController.text.isEmpty
        /*carNameController.text.isEmpty ||
        selectedCarColor == null*/
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Color.fromARGB(255, 255, 99, 88),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      return;
    }

    if (englishLettersController.text.length != 3) {
      // Display a message indicating that the English field should have exactly 3 characters
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please ensure the English field has exactly 3 characters'),
          backgroundColor: Color.fromARGB(255, 255, 99, 88),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      return;
    } else {
      List<String> allowedLetters = [
        'A',
        'B',
        'J',
        'D',
        'R',
        'S',
        'X',
        'T',
        'E',
        'G',
        'K',
        'L',
        'Z',
        'N',
        'H',
        'U',
        'V'
      ];

      List<String> nonMatchingLetters = [];

      for (int i = 0; i < englishLettersController.text.length; i++) {
        if (!allowedLetters
            .contains(englishLettersController.text[i].toUpperCase())) {
          nonMatchingLetters.add(englishLettersController.text[i]);
        }
      }

      if (nonMatchingLetters.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Characters not allowed: ${nonMatchingLetters.join(', ')}'),
            backgroundColor: Color.fromARGB(255, 255, 99, 88),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
        return;
      }
    }

    // Check if numbersController has more than 4 characters
    if (numbersController.text.length > 4) {
      // Display a message indicating that the Numbers field should have up to 4 digits
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter up to 4 digits in the Numbers field'),
          backgroundColor: Color.fromARGB(255, 255, 99, 88),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      return;
    }

    editCarInfoHandler editCarInfoHandlerObj =
        editCarInfoHandler(carId: widget.carId);

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await editCarInfoHandlerObj.formUpdata(
          selectedFuelType, englishLettersController, numbersController
          /*carNameController,
        selectedCarColor,*/
          );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => carInfo(carId: widget.carId)),
      );
    } else {
      // Handle the case where the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please sign in before adding a car'),
          backgroundColor: Color.fromARGB(255, 255, 99, 88),
        ),
      );
    }
  }

  Future<void> fetchCarData() async {
    Map<String, dynamic> data =
        await editCarInfoHandler.getCarData(widget.carId);

    setState(() {
      carDataInfo = data;

      if (carDataInfo['fuelType'] != null) {
        selectedFuelType = carDataInfo['fuelType'];
      }

      if (carDataInfo['englishLetters'] != null) {
        englishLettersController =
            TextEditingController(text: carDataInfo['englishLetters']);
      }

      if (carDataInfo['plateNumbers'] != null) {
        numbersController =
            TextEditingController(text: carDataInfo['plateNumbers']);
      }
    });
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
                                updataFormData();
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
