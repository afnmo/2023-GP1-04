import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/employee/report_bill.dart';

class plantPage extends StatefulWidget {
  final String email;

  const plantPage({Key? key, required this.email}) : super(key: key);

  @override
  plantPageState createState() => plantPageState();
}

class plantPageState extends State<plantPage> {
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
          'Plate Number',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          return ListView.builder(
            itemCount: carDocs.length,
            itemBuilder: (context, index) {
              var carData = carDocs[index].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    String carId = carDocs[index].id;
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
                    borderRadius: BorderRadius.circular(
                        20), // Set the border radius to achieve oval shape
                    child: Container(
                      color: Colors.grey, // Set card color to gray
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
