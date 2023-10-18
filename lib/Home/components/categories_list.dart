import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'dart:ui' as ui;
//import 'categories_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: 200.0), // Adjust the top padding as needed
          child: Column(
            children: [
              BlurredImageWithText(),
              CategoriesListMallika1(),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesListMallika1 extends StatefulWidget {
  const CategoriesListMallika1({Key? key}) : super(key: key);

  @override
  _CategoriesListMallika1State createState() => _CategoriesListMallika1State();
}

class _CategoriesListMallika1State extends State<CategoriesListMallika1> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Adjust the height to accommodate a single row
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CategoryCardMallika1(
            title: "Gas Stations",
            image: "assets/gasStation.png",
            onTap: () {
              // Add your navigation logic here
            },
            selected: false,
          ),
          CategoryCardMallika1(
            title: "Fuel Consumption",
            image: "assets/consumption.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "Promotions",
            image: "assets/promos.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "Add Car",
            image: "assets/addCar.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "My Cars",
            image: "assets/myCars.png",
            onTap: () {
              // Add your navigation logic here
            },
            selected: false,
          ),
          CategoryCardMallika1(
            title: "Account",
            image: "assets/account.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "Settings",
            image: "assets/settings.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "About Us",
            image: "assets/about.png",
            onTap: () {
              //Add your navigation logic here
            },
          ),
        ],
      ),
    );
  }
}

class CategoryCardMallika1 extends StatelessWidget {
  final String title;
  final String image;
  final Function() onTap;
  final bool selected;

  const CategoryCardMallika1({
    required this.title,
    required this.image,
    required this.onTap,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF6EA67C),
                //border: Border.all(
                //width: selected ? 2 : 0,
                //color: const Color(0xffFF8527),
                //),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                child: Image.asset(
                  image, // Use Image.asset instead of Image.network
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 12.5,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: selected ? const Color(0xffFF8527) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlurredImageWithText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0), // Adjust the padding as needed
      child: Container(
        height: 200,
        child: Stack(
          children: [
            Image.asset(
              'assets/chart.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Color(0xFF6EA67C)
                      .withOpacity(0.3), // Adjust the opacity as needed
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Want to know your gas costs?\nAdd a car, \nand monitor your costs!',
                    style: TextStyle(
                      color: Color(0xFF6EA67C),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add car button action
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF6EA67C),
                      ),
                    ),
                    child: Text('Add Car'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
