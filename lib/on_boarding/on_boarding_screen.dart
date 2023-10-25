import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/on_boarding/on_boarding_model.dart';
import 'package:gp91/on_boarding/on_boarding_page_widget.dart';
import 'package:gp91/welcome/welcome_screen.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentPage = 0;

  final liqController = LiquidController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final page1 = OnBoardingModel(
      image: "assets/images/onboarding1.png",
      title: "Real-time Gas Station Occupancy",
      subTitle:
          "Discover real-time gas station occupancy and avoid long lines with just a tap. Find the nearest available pump and save time on your journey.",
      counterText: "1/3",
      bgColor: Colors.white,
    );

    final page2 = OnBoardingModel(
        image: "assets/images/onboarding2.png",
        title: "Fuel Consumption Stats",
        subTitle:
            "Track your vehicle's fuel efficiency effortlessly. Get personalized statistics on your fuel consumption to make smarter driving choices.",
        counterText: "2/3",
        bgColor: const Color(0xfffddcdf));

    final page3 = OnBoardingModel(
      image: "assets/images/onboarding3.png",
      title: "Fuel Expense Reports",
      subTitle:
          "Simplify your budgeting with our organized fuel expense reports. Keep your spending in check and access clear financial insights on the go.",
      counterText: "3/3",
      bgColor: const Color(0xffffdcbd),
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            liquidController: liqController,
            pages: [
              OnBoardingPageWidget(model: page1, size: size),
              OnBoardingPageWidget(model: page2, size: size),
              OnBoardingPageWidget(model: page3, size: size),
              WelcomeScreen(),
            ],
            slideIconWidget:
                currentPage < 3 ? const Icon(Icons.arrow_back_ios) : null,
            enableSideReveal: currentPage < 3,
            onPageChangeCallback: onPageChangeCallback,
            enableLoop: false,
          ),
          Visibility(
            visible: currentPage < 3,
            child: Positioned(
              bottom: 70,
              child: OutlinedButton(
                // onPressed: () {
                //   int nextPage = liqController.currentPage + 1;
                //   liqController.animateToPage(page: nextPage);
                // },
                onPressed: () {
                  if (currentPage < 3) {
                    int nextPage = liqController.currentPage + 1;
                    liqController.animateToPage(page: nextPage);
                  }
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black26),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  foregroundColor: Colors.white,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
          Visibility(
            visible: currentPage < 3,
            child: Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Get.to(() => WelcomeScreen());
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: currentPage < 3,
            child: Positioned(
              bottom: 20,
              child: AnimatedSmoothIndicator(
                activeIndex: liqController.currentPage,
                count: 3,
                effect: const WormEffect(
                  activeDotColor: Color(0xff272727),
                  dotHeight: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPageChangeCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }
}
