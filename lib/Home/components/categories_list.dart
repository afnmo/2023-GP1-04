import 'package:flutter/material.dart';
import 'package:gp91/settings/settings_page.dart';
import 'package:gp91/about_us/about_us.dart';

class CategoriesListMallika1 extends StatefulWidget {
  const CategoriesListMallika1({Key? key}) : super(key: key);

  @override
  // _CategoriesListMallika1State createState() => _CategoriesListMallika1State();
  State<StatefulWidget> createState() => _CategoriesListMallika1State();
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
            image: "assets/images/gasStation2.png",
            onTap: () {
              // Add your navigation logic here
            },
            selected: false,
          ),
          CategoryCardMallika1(
            title: "Fuel Consumption",
            image: "assets/images/consumption2.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "Promotions",
            image: "assets/images/promos2.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "Add Car",
            image: "assets/images/addCar2.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "My Cars",
            image: "assets/images/myCars2.png",
            onTap: () {
              // Add your navigation logic here
            },
            selected: false,
          ),
          CategoryCardMallika1(
            title: "Account",
            image: "assets/images/account2.png",
            onTap: () {
              // Add your navigation logic here
            },
          ),
          CategoryCardMallika1(
            title: "Settings",
            image: "assets/images/settings2.png",
            onTap: () {
              // Add your navigation logic here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          CategoryCardMallika1(
            title: "About Us",
            image: "assets/images/about2.png",
            onTap: () {
              //Add your navigation logic here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
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
                color: const Color(0xFF6EA67C),
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
