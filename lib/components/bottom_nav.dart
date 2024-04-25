import 'package:flutter/material.dart';
import 'package:gp91/bill/body.dart';
import 'package:gp91/station/station.dart';
import 'package:gp91/car/car.dart';
import '../settings/settings_page.dart';
import 'package:gp91/home/screens/home_screen.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  const BottomNav({
    Key? key,
    required this.currentIndex,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  // _BottomNavState createState() => _BottomNavState();
  State<StatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF6EA67C),
        currentIndex: widget.currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromRGBO(251, 247, 247, 0.65),
        onTap: (int index) {
          widget.onIndexChanged(index);
          navigateToPage(context, index); // Call the navigateToPage function
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              color: const Color(0xFF6EA67C),
              child: Image.asset(
                'assets/images/gasStation3.png',
                width: 25,
                height: 25,
              ),
            ),
            label: 'Gas stations',
          ),
          BottomNavigationBarItem(
            icon: Container(
              color: const Color(0xFF6EA67C),
              child: Image.asset(
                'assets/images/myCars3.png',
                width: 25,
                height: 25,
              ),
            ),
            label: 'My cars',
          ),
          BottomNavigationBarItem(
            icon: Container(
              color: const Color(0xFF6EA67C),
              child: Image.asset(
                'assets/images/home.png',
                width: 25,
                height: 25,
              ),
            ),
            label: 'Home',
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
          BottomNavigationBarItem(
            icon: Container(
              color: const Color(0xFF6EA67C),
              child: Image.asset(
                'assets/images/bill3.png',
                width: 25,
                height: 25,
              ),
            ),
            label: 'Bill',
          ),
        ],
      ),
    );
  }

  void navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Station()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScreenBill()),
        );
        break;
    }
  }
}
