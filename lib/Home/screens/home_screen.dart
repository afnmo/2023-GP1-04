import 'package:gp91/Home/components/categories_list.dart';
import 'package:gp91/home/components/topBar.dart';
import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'package:gp91/home/components/blurred_image_with_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  // _HomeScreenState createState() => _HomeScreenState();
  State<StatefulWidget> createState() => _HomeScreenState();
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
      appBar: TopBar(),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Journey,',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 40,
                      ),
                    ),
                    const Text(
                      'Our Priority',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 40,
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 40,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Fueling',
                            style: TextStyle(
                                color: Color(0xFF6EA67C)), // Change the color
                          ),
                          TextSpan(
                            text: ' Made Smart.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: BlurredImageWithText(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: CategoriesListMallika1(),
            ),
          ],
        ),
      ),
    );
  }
}
