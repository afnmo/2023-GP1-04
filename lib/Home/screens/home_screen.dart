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