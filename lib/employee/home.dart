import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/employee/components/qr_or_plate.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:gp91/employee/components/top_bar.dart';
import 'package:gp91/employee/bill/body.dart';
import 'package:gp91/settings/settings_page.dart'; // Import the SettingsPage

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  State<Home> createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<Home> {
  var getResult = 'QR Code Result';
  int _currentIndex = 0;
  String? _billScreenEmail;
  String? _employeeName;

  @override
  void initState() {
    super.initState();
    fetchEmployeeName();
  }

  Future<void> fetchEmployeeName() async {
    final firestoreInstance = FirebaseFirestore.instance;
    final querySnapshot = await firestoreInstance
        .collection('Station_Employee')
        .where('email', isEqualTo: widget.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _employeeName = querySnapshot.docs.first['firstName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 10.0,
                left: 20.0,
              ),
              child: Text(
                'Hi ${_employeeName ?? '...'}!',
                style: const TextStyle(
                  fontSize: 25,
                  color: Color(0xFF6EA67C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _currentIndex == 0
                ? _HomeBody(
                    email: widget.email,
                    onNavigateToPlatePage: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRorPlate(email: widget.email),
                        ),
                      );
                    },
                  )
                : ScreenBill(email: _billScreenEmail ?? widget.email),
          ],
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
              if (_currentIndex == 1) {
                _billScreenEmail = widget.email;
              }
            });
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenBill(email: widget.email),
                ),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                color: const Color(0xFF6EA67C),
                child: Image.asset('assets/images/dollarSign.png',
                    width: 25, height: 25),
              ),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Container(
                color: const Color(0xFF6EA67C),
                child: Image.asset('assets/images/bill3.png',
                    width: 25, height: 25),
              ),
              label: 'History Bill',
            ),
            BottomNavigationBarItem(
              icon: Container(
                color: const Color(0xFF6EA67C),
                child: Image.asset(
                  'assets/images/settings3.png',
                  width: 25,
                  height: 25,
                ),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final String email;
  final VoidCallback onNavigateToPlatePage;

  const _HomeBody({
    Key? key,
    required this.email,
    required this.onNavigateToPlatePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Container(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/report_bill.gif',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Report the bill of the \n driver car in your station!",
                    style: TextStyle(
                      color: Color(0xFF6EA67C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      onNavigateToPlatePage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReportBillButton(
                          onPressed: () {
                            onNavigateToPlatePage();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportBillButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReportBillButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 146, 158, 145),
        ),
        child: SizedBox(
          width: 150,
          height: 50,
          child: Center(
            child: const Text(
              "Report Bill",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
