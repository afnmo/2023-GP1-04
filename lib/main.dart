import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:gp91/consumption/fuel_firebase.dart';
import 'package:gp91/firebase_auth/user_repository/auth_repository.dart';
import 'package:gp91/firebase_auth/user_repository/user_repository.dart';
import 'package:gp91/on_boarding/on_boarding_screen.dart';


void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp().then((value) => Get.put(AuthRepository()));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(UserRepository()); // Register UserRepository
  Get.put(AuthRepository()); // Register AuthRepository
  Get.put(FuelFirebase());

  // resetOnboardingFlag();
  // // Check if the user has seen the onboarding screen before
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  // // Determine the initial route based on whether the user has seen the onboarding
  // final initialRoute = hasSeenOnboarding ? '/welcome' : '/onboarding';
  // runApp(MyApp(initialRoute: initialRoute));

  runApp(const MyApp());
}

// Future<void> resetOnboardingFlag() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('hasSeenOnboarding', false);
// }

class MyApp extends StatelessWidget {
  // final String initialRoute;
  const MyApp({super.key});
  //, required this.initialRoute

  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: OnBoardingScreen(),
      // home: ListStyleTest(),

      // home: IntroFuel(),
      // home: FuelResult(),
      // home: ListConsumption(),

      // initialRoute:
      //     initialRoute, // Set the initial route based on user's previous interaction
      // routes: {
      //   '/welcome': (context) => WelcomeScreen(),
      //   '/onboarding': (context) {
      //     // Set the 'hasSeenOnboarding' flag to true and show the onboarding screen
      //     SharedPreferences.getInstance().then((prefs) {
      //       prefs.setBool('hasSeenOnboarding', true);
      //     });
      //     return OnBoardingScreen();
      //   },
      // },
    );
  }
}
