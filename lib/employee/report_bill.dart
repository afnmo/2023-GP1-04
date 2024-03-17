import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gp91/employee/home.dart';
import 'package:intl/intl.dart';

class ReportBill extends StatefulWidget {
  final String documentId;
  final String email;

  ReportBill({Key? key, required this.documentId, required this.email})
      : super(key: key);

  @override
  _ReportBillState createState() => _ReportBillState();
}

class _ReportBillState extends State<ReportBill> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedFuelType;

  void _saveReport(BuildContext context) async {
    String amount = _amountController.text;
    if (amount.isNotEmpty && _selectedFuelType != null) {
      try {
        DocumentSnapshot carDoc = await FirebaseFirestore.instance
            .collection('Cars')
            .doc(widget.documentId)
            .get();

        if (carDoc.exists) {
          String userid = carDoc['userId'];
          DateTime currentDate = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
          String day = DateFormat('dd')
              .format(currentDate); // Format day with leading zero
          String month = DateFormat('MM')
              .format(currentDate); // Format month with leading zero
          String year = DateFormat('yyyy')
              .format(currentDate); // Format year with leading zero
          String name = await getEmployeeNameByEmail(widget.email);
          String station = await getStationName(widget.email);
          String manager_id = await getBranchId(widget.email);

          await FirebaseFirestore.instance.collection('Bills').add({
            'carId': widget.documentId,
            'userId': userid,
            'amount': amount,
            'date': formattedDate,
            'day': day,
            'month': month,
            'year': year,
            'employeeName': name,
            'stationName': station,
            'fuelType': _selectedFuelType,
            'branch_manager_id': manager_id,
          });

          Get.snackbar(
            "Successfully sent!",
            "The bill was saved successfully.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color.fromARGB(255, 21, 153, 4).withOpacity(0.1),
            colorText: Color.fromARGB(255, 6, 227, 43),
          );
          // Navigate back to the home page after displaying the success message
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                email: widget.email,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Car details not found.'),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      Get.snackbar(
        "Please enter the amount and select fuel type",
        "   ",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color.fromARGB(255, 236, 50, 13).withOpacity(0.1),
        colorText: const Color.fromARGB(255, 246, 244, 243),
      );
    }
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
          'Report Bill',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Image.asset('assets/images/bill.png', width: 200, height: 200),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter the amount of money\nthat the driver buys during fueling his car",
                  style: TextStyle(
                    color: Color.fromRGBO(54, 80, 61, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          suffixIcon: Icon(Icons.monetization_on),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.black),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedFuelType,
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text('Fuel Type'),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedFuelType = value;
                          });
                        },
                        items: <String>['91', '95', 'Diesel']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Material(
                    color: Color(0xFFFFCEAF),
                    child: InkWell(
                      splashColor: Colors.white,
                      child: SizedBox(
                        width: 90,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Report',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async => _saveReport(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> getEmployeeNameByEmail(String email) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Station_Employee')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String employeeName_first = querySnapshot.docs.first['firstName'];
      String employeeName_last = querySnapshot.docs.first['lastName'];
      String name = employeeName_first + " " + employeeName_last;
      return name;
    } else {
      return ''; // Default to an empty string
    }
  } catch (e) {
    print('Error fetching employee name: $e');
    return ''; // Default to an empty string
  }
}

Future<String> getStationName(String email) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Station_Employee')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String branchManagerId = querySnapshot.docs.first['branch_manager_id'];

      DocumentSnapshot<Map<String, dynamic>> branchManagerSnapshot =
          await FirebaseFirestore.instance
              .collection('Branch_Manager')
              .doc(branchManagerId)
              .get();

      if (branchManagerSnapshot.exists) {
        String stationId = branchManagerSnapshot['station_id'];

        DocumentSnapshot<Map<String, dynamic>> stationSnapshot =
            await FirebaseFirestore.instance
                .collection('Station')
                .doc(stationId)
                .get();

        if (stationSnapshot.exists) {
          return stationSnapshot['name'] ?? '';
        }
      }
    }

    return ''; // Default to an empty string
  } catch (e) {
    print('Error fetching station name: $e');
    return ''; // Default to an empty string
  }
}

Future<String> getBranchId(String email) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Station_Employee')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String branchManagerId = querySnapshot.docs.first['branch_manager_id'];
      return branchManagerId;
    }

    return ''; // Default to an empty string
  } catch (e) {
    print('Error fetching station name: $e');
    return ''; // Default to an empty string
  }
}
