import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/Station/Station.dart';
import 'package:gp91/car/car.dart';
import 'package:gp91/consumption/fuel_cars.dart';
import 'package:gp91/consumption/fuel_prev.dart';
import 'package:gp91/consumption/fuel_result.dart';
import 'package:gp91/settings/settings_page.dart';
import 'package:gp91/about_us/about_us.dart';

class CategoriesListMallika1 extends StatefulWidget {
  const CategoriesListMallika1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoriesListMallika1State();
}

class _CategoriesListMallika1State extends State<CategoriesListMallika1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CategoryCardMallika1(
                title: "Gas Stations",
                image: "assets/images/gasStation2.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Station()),
                  );
                },
                selected: false,
              ),
            ),
            Expanded(
              child: CategoryCardMallika1(
                title: "Fuel Consumption",
                image: "assets/images/fuelhome3.png",
                onTap: () {
                  Get.to(() => FuelCars());
                },
              ),
            ),
            Expanded(
              child: CategoryCardMallika1(
                title: "Promotions",
                image: "assets/images/promos2.png",
                onTap: () {
                  // Add your navigation logic here
                },
              ),
            ),
            Expanded(
              child: CategoryCardMallika1(
                title: "Fuel Stats",
                image: "assets/images/consumption2.png",
                onTap: () {
                  Get.to(() => FuelResult());
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CategoryCardMallika1(
                title: "My Cars",
                image: "assets/images/myCars2.png",
                onTap: () {
                  Get.to(() => CarPage());
                  // Add your navigation logic here
                },
                selected: false,
              ),
            ),
            Expanded(
              child: CategoryCardMallika1(
                title: "Fuel Records",
                image: "assets/images/history.png",
                onTap: () {
                  Get.to(() => FuelPrev());
                  // Add your navigation logic here
                },
              ),
            ),
            Expanded(
              child: CategoryCardMallika1(
                title: "Settings",
                image: "assets/images/settings2.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ),
            Expanded(
              child: CategoryCardMallika1(
                title: "About Us",
                image: "assets/images/about2.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

////////////////////////
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
      padding: const EdgeInsets.all(2),
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
                  width: 70,
                  height: 70,
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
                fontSize: 12,
                color: selected ? const Color(0xffFF8527) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
