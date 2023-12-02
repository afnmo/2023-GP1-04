import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'car_data.dart';
import 'package:gp91/car/car.dart';
import 'form_data_handler.dart';

class AddCarBody extends StatefulWidget {
  const AddCarBody({Key? key}) : super(key: key);

  @override
  _addCarBodyState createState() => _addCarBodyState();
}

class _addCarBodyState extends State<AddCarBody> {
  double fixedWidth = 350.0;
  double fixedHeight = 200.0;

  List<String> _uniqueManufacturers = [];
  List<String> carModels = [];
  List<String> fuelEconomys = [];
  List<String> years = [];

  String? selectedYear;
  List<String> fuelTypes = ['91', '95', 'Diesel'];
  String? selectedFuelType;
  String? selectedFuelEconomy;
  String? selectedCarMake;
  String? selectedCarModel;
  TextEditingController englishLettersController = TextEditingController();
  TextEditingController numbersController = TextEditingController();
  TextEditingController carNameController = TextEditingController();
  String? selectedCarColor;
  CarData carDataObj = CarData();

// color list
  List<String> colorMap = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Orange',
    'Purple',
    'Pink',
    'Teal',
    'Cyan',
    'Amber',
    'Indigo',
    'Lime',
    'Brown',
    'Grey',
    'Black',
    'White',
  ];

  @override
  void initState() {
    super.initState();
    extractManufacturers();
  }

// extract manufacturers
  void extractManufacturers() async {
    List<String> manufacturers = await CarData.extractManufacturers();
    setState(() {
      _uniqueManufacturers = manufacturers;
    });
  }

// fetch car models based on the selected car make
  Future<void> fetchCarModels(String make) async {
    List<String> models = await carDataObj.getVehicleModels(make);
    setState(() {
      carModels = models;
    });
  }

// fetch years based on the selected car make and model
  Future<void> fetchYears(String make, String model) async {
    List<String> models = await carDataObj.getYearsForMakeAndModel(make, model);
    setState(() {
      years = models;
    });
  }

// fetch Fuel economy based on the selected car make, model, and year
  Future<void> fetchFuelEconomy(String year, String make, String model) async {
    List<String> Economys = await carDataObj.getFuelEconomy(year, make, model);
    setState(() {
      fuelEconomys = Economys;
    });
  }

  void submitFormData() async {
    // Check if any field is empty
    if (selectedCarMake == null ||
        selectedCarModel == null ||
        selectedYear == null ||
        selectedFuelType == null ||
        selectedFuelEconomy == null ||
        englishLettersController.text.isEmpty ||
        numbersController.text.isEmpty ||
        carNameController.text.isEmpty ||
        selectedCarColor == null) {
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

// Check if English field should have not exactly 3 characters
    if (englishLettersController.text.length != 3) {
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
      // Display a message indicating that Characters not allowed in Saudi plate
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
                'Characters not allowed in Saudi plate: ${nonMatchingLetters.join(', ')}'),
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

    FormDataHandler formDataHandlerObj = FormDataHandler();

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await formDataHandlerObj.formData(
        selectedCarMake,
        selectedCarModel,
        selectedYear,
        selectedFuelType,
        selectedFuelEconomy,
        englishLettersController,
        numbersController,
        carNameController,
        selectedCarColor,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CarPage(),
        ),
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

  Widget build(BuildContext context) {
    @override
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

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
          'Add new car',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment(-0.8, 0.8),
                              child: Text(
                                'Basic information',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6EA67C),
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
                                      fetchCarModels(selectedCarMake!);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Make',
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
                                        selectedYear = null;
                                        selectedFuelEconomy = null;
                                      });
                                      fetchYears(
                                          selectedCarMake!, selectedCarModel!);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Model',
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
                                    selectedFuelEconomy = null;
                                  });
                                  fetchFuelEconomy(selectedYear!,
                                      selectedCarMake!, selectedCarModel!);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Year',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
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
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
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
                                        fuelEconomys.map((String FuelEconomy) {
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
                                      labelText: 'Fuel Economy',
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
                                'Plate information',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6EA67C),
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
                                keyboardType: TextInputType.text,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-Z]*$')),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'English letters',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
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
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter
                                      .digitsOnly // Allow only numeric input
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Numbers',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  prefixIcon: Image.asset(
                                    'assets/icons/numbers.png',
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
                                'Style information',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6EA67C),
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
                                value: selectedCarColor,
                                items: colorMap.map((String carColor) {
                                  return DropdownMenuItem<String>(
                                    value: carColor,
                                    child: Text(carColor),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCarColor = newValue;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Car color',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.color_lens,
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
                                controller: carNameController,
                                keyboardType: TextInputType.text,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'^[a-zA-Z ]*$')), // Allow only English letters
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Car name',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.directions_car,
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
                                submitFormData();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFFCEAF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(355, 38),
                              ),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
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
