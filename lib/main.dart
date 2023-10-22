import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:gp91/firebase_auth/user_repository/auth_repository.dart';
import 'package:gp91/on_boarding/on_boarding_screen.dart';
import 'package:gp91/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthRepository()));

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
  // // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   // Map<String, String> dataToSave = {'name': 'station1'};
  //   // FirebaseFirestore.instance.collection("Station").add(dataToSave);
  //   return GetMaterialApp(
  //     // IDK What's the point of this line.
  //     debugShowCheckedModeBanner: false,
  //     title: 'Flutter Auth',

  //     theme: ThemeData(
  //       // primaryColor: bkgPrimaryColor,
  //       scaffoldBackgroundColor: Colors.white,
  //     ),
  //     //WelcomeScreen()
  //     home: WelcomeScreen(),
  //   );
  // }
}

// class FirstRoute extends StatelessWidget {
//   const FirstRoute({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('First Route'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               child: const Text('Afnan'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Body()),
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Rahaf'),
//               onPressed: () {
//                 // Handle Rahaf button click here
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => Body()),
//                 // );
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Sara'),
//               onPressed: () {
//                 // Handle Sara button click here
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => Body()),
//                 // );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
