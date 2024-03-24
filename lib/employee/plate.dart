import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/employee/report_bill.dart';

class PlantPage extends StatefulWidget {
  final String email;

  const PlantPage({Key? key, required this.email}) : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6EA67C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search Plate Number...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild to update filtered list
                },
              )
            : Text(
                'Plate Number',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Cars').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final carDocs = snapshot.data!.docs;
          List<DocumentSnapshot> filteredCars = [];
          if (_isSearching) {
            filteredCars = carDocs.where((car) {
              var plateNumber = (car.data()
                  as Map<String, dynamic>)['plateNumbers'] as String?;
              var englishLetters = (car.data()
                  as Map<String, dynamic>)['englishLetters'] as String?;
              if (plateNumber != null && englishLetters != null) {
                // Check if plate number contains the search query
                if (plateNumber
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase())) {
                  return true;
                }
                // Check if english letters contain the search query
                if (englishLetters
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase())) {
                  return true;
                }
              }
              return false;
            }).toList();
          } else {
            filteredCars = carDocs;
          }
          return ListView.builder(
            itemCount: filteredCars.length,
            itemBuilder: (context, index) {
              var carData = filteredCars[index].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    String carId = filteredCars[index].id;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportBill(
                          documentId: carId,
                          email: widget.email,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  carData['plateNumbers'] as String? ?? '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  convertEnglishToArabicNumbers(
                                    carData['plateNumbers'] as String? ?? '',
                                  ),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/images/KSA.png',
                              width: 40,
                              height: 50,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  (carData['englishLetters'] as String?)
                                          ?.toUpperCase() ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  (carData['arabicLetters'] as String?)
                                          ?.toUpperCase() ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String convertEnglishToArabicNumbers(String input) {
  return input.replaceAllMapped(RegExp(r'[0-9]'), (match) {
    switch (match.group(0)) {
      case '0':
        return '٠';
      case '1':
        return '١';
      case '2':
        return '٢';
      case '3':
        return '٣';
      case '4':
        return '٤';
      case '5':
        return '٥';
      case '6':
        return '٦';
      case '7':
        return '٧';
      case '8':
        return '٨';
      case '9':
        return '٩';
      default:
        return match.group(0)!;
    }
  });
}
