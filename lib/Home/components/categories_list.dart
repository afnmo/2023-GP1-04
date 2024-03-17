import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/car/car_body.dart';
import 'package:gp91/consumption/fuel_prev.dart';
import 'package:gp91/consumption/fuel_result.dart';
import 'package:gp91/about_us/about_us.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CategoryCard(
            title: "Consumption",
            image: "assets/images/fuelhome3.png",
            onTap: () {
              Get.to(() => const CarBody(
                    isConsumption: true,
                  ));
            },
          ),
        ),
        Expanded(
          child: CategoryCard(
            title: "Fuel Stats",
            image: "assets/images/consumption2.png",
            onTap: () {
              Get.to(() => const FuelResult());
            },
          ),
        ),
        Expanded(
          child: CategoryCard(
            title: "Fuel Records",
            image: "assets/images/history.png",
            onTap: () {
              Get.to(() => const FuelPrev());
            },
          ),
        ),
        // Expanded(
        //   child: CategoryCard(
        //     title: "Promotions",
        //     image: "assets/images/promos2.png",
        //     onTap: () {
        //       // Add your navigation logic here
        //     },
        //   ),
        // ),
        Expanded(
          child: CategoryCard(
            title: "About Us",
            image: "assets/images/about2.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
        ),
      ],
    );
  }
}

//////////////////////////////
class CategoryCard extends StatelessWidget {
  // cards attributes
  final String title;
  final String image;
  final Function() onTap;
  final bool selected;

  const CategoryCard({
    required this.title,
    required this.image,
    required this.onTap,
    // false so it is not auto selected
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
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                child: Image.asset(
                  image,
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
                fontSize: 13,
                color: selected ? const Color(0xffFF8527) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
