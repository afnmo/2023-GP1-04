import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/employee/bill/TimeLineTileUI.dart';
import 'package:gp91/employee/components/top_bar.dart';
import 'package:gp91/employee/home.dart';
import 'package:gp91/settings/settings_page.dart';

class ScreenBill extends StatefulWidget {
  const ScreenBill({
    Key? key,
    required this.email,
  }) : super(key: key);
  final String email;

  @override
  State<ScreenBill> createState() => _ScreenBillState();
}

Stream<List<DocumentSnapshot>> fetchBillsAsStream(String email) async* {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Station_Employee')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String employee_name_first = querySnapshot.docs[0]['firstName'];
      String employee_name_last = querySnapshot.docs[0]['lastName'];
      String employee_name = employee_name_first + " " + employee_name_last;

      final billCollection = FirebaseFirestore.instance.collection('Bills');
      Stream<QuerySnapshot> billQueryStream = billCollection
          .where('employeeName', isEqualTo: employee_name)
          .snapshots();

      await for (QuerySnapshot billSnapshot in billQueryStream) {
        yield billSnapshot.docs;
      }
    }
  } catch (e) {
    print('Error fetching bills: $e');
    yield [];
  }
}

class _ScreenBillState extends State<ScreenBill> {
  int _currentIndex = 1; // Current index for the bottom navigation bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: fetchBillsAsStream(widget.email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No bills found for the user.');
            } else {
              List<DocumentSnapshot> billDocs = snapshot.data!;

              // Reverse the list to display newest bills at the top
              billDocs = billDocs.reversed.toList();

              return ListView.builder(
                itemCount: billDocs.length,
                itemBuilder: (context, index) {
                  var billData = billDocs[index].data() as Map<String, dynamic>;

                  return TimeLineTileUI(
                    isFirst: index == 0,
                    isLast: index == billDocs.length - 1,
                    isPast:
                        true, // You may need to determine this based on date
                    eventChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.date_range_outlined,
                                color: Colors.white),
                            const SizedBox(width: 15.0),
                            Text(
                              ' ${billData['date']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '#${billDocs[index].id}', // Displaying bill ID here
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Amount: ${billData['amount']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        // Display other fields as needed
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF6EA67C),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
              return;
            }
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 0) {
                // Navigate to Home page when "Report" button is tapped
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(email: widget.email),
                  ),
                );
              } else if (_currentIndex == 1) {
                // You may need to navigate to a different page for "History Bill"
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenBill(email: widget.email),
                  ),
                );
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                color: const Color(0xFF6EA67C),
                child: Icon(Icons.attach_money),
              ),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Container(
                color: const Color(0xFF6EA67C),
                child: Image.asset('assets/images/bill2.png',
                    width: 25, height: 25),
              ),
              label: 'History Bill',
            ),
            BottomNavigationBarItem(
              icon: Container(
                color: const Color(0xFF6EA67C),
                child: Icon(Icons.settings),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
