import 'package:gp91/Home/components/bar_graph/monthly_bar_graph.dart';
import 'package:gp91/Home/components/bar_graph/annual_bar_graph.dart';
import 'package:gp91/Home/components/bar_graph/get_expenses.dart';
import 'package:gp91/Home/components/categories_list.dart';
import 'package:gp91/Home/components/check_car.dart';
import 'package:gp91/employee/components/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'package:gp91/home/components/blurred_image_with_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/Home/components/get_user_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GetUserName getUserName = GetUserName();
  String? userName;
  bool userNameFetched = false; // Flag to track if user name is fetched
  bool amountFetched = false;
  List<double> monthlySummary = [];
  List<double> annualSummary = [];
  bool? showGraph;
  bool showMonthly = true;
  int _currentIndex = 2;
  

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user name
    _fetchSummary();
  }

  Future<void> _fetchUserName() async {
    userName = await getUserName.getUserName();
    setState(() {
      userNameFetched = true; // Update flag when user name is fetched
    });
  }

  Future<void> _fetchSummary() async {
    showGraph = await checkCarExists();

    if (showGraph == true) {
      final QuerySnapshot billsStream =
          await FirebaseFirestore.instance.collection('Bills').get();
      GetExpenses getExpenses = GetExpenses(billsDocuments: billsStream);
      List<double> amounts = await getExpenses.getMontlhyAmounts();
      List<double> amounts2 = await getExpenses.getAnnualAmounts();

      setState(() {
        amountFetched = true;
        monthlySummary = amounts;
        annualSummary = amounts2;
      });
    }
  }

  Widget _buildGraphWidget() {
    if (!userNameFetched && showGraph == null && showGraph == false) {
      // Show CircularProgressIndicator if user name is not fetched or showGraph is false
      return CircularProgressIndicator(color: Color(0xFF6EA67C));
    } else if (amountFetched && showGraph == true) {
      if (showMonthly) {
        return SizedBox(
          height: 250,
          width: 395,
          child: MonthlyBarGraph(monthlySummary: monthlySummary),
        );
      } else {
        return SizedBox(
          height: 250,
          width: 395,
          child: AnnualBarGraph(annualSummary: annualSummary),
        );
      }
    }
    return Container(); // Render an empty container if showGraph is false
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 10.0,
                left: 20.0,
              ),
              child: Text(
                'Hi ${userName ?? '...'}!',
                style: const TextStyle(
                  fontSize: 25,
                  color: Color(0xFF6EA67C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showGraph == true) // Display graph if showGraph is true
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 80.0),
                  child: ToggleButtons(
                    isSelected: [showMonthly, !showMonthly],
                    onPressed: _toggleGraph,
                    selectedColor: const Color.fromRGBO(110, 166, 124, 1),
                    fillColor: const Color.fromRGBO(110, 166, 124, 0.2),
                    splashColor: const Color.fromRGBO(110, 166, 124, 0.3),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('monthly costs'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('annual costs'),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: _buildGraphWidget(),
            ),
            if (amountFetched == false)
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: BlurredImageWithText()),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CategoriesList(),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleGraph(int index) {
    setState(() {
      showMonthly = index == 0;
    });
  }

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

// //hi
// class _HomeScreenState extends State<HomeScreen> {
//   GetUserName getUserName = GetUserName();
//   String? userName;
//   List<double> monthlySummary = [];
//   List<double> annualSummary = [];
//   bool? showGraph;
//   bool showMonthly = true;
//   int _currentIndex = 2;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserName();
//     _fetchSummary();
//   }

//   Future<void> _fetchUserName() async {

//     userName = await getUserName.getUserName();
//     print("username:");
//     print(userName);
//   }

//   Future<void> _fetchSummary() async {
//     showGraph = await checkCarExists();

//     if (showGraph == true) {
//       final QuerySnapshot billsStream =
//           await FirebaseFirestore.instance.collection('Bills').get();
//       GetExpenses getExpenses = GetExpenses(billsDocuments: billsStream);
//       List<double> amounts = await getExpenses.getMontlhyAmounts();
//       List<double> amounts2 = await getExpenses.getAnnualAmounts();

//       if (mounted) {
//         setState(() {
//           monthlySummary = amounts;
//           annualSummary = amounts2;
//         });
//       }
//     }
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _fetchSummary();
//   // }

//   // Future<void> _fetchSummary() async {
//   //   userName = await getUserName.getUserName();
//   //   showGraph = await checkCarExists();

//   //   if (showGraph == true) {
//   //     final QuerySnapshot billsStream =
//   //         await FirebaseFirestore.instance.collection('Bills').get();
//   //     GetExpenses getExpenses = GetExpenses(billsDocuments: billsStream);
//   //     List<double> amounts = await getExpenses.getMontlhyAmounts();
//   //     List<double> amounts2 = await getExpenses.getAnnualAmounts();

//   //     // Check if the widget is still mounted before updating the state
//   //     print(mounted);
//   //     if (mounted) {
//   //       setState(() {
//   //         monthlySummary = amounts;
//   //         annualSummary = amounts2;
//   //       });
//   //     }
//   //   }
//   // }

//   void _toggleGraph(int index) {
//     setState(() {
//       showMonthly = index == 0;
//     });
//   }

//   Widget _buildGraphWidget() {
//     print(showGraph);
//     if (showGraph == null || showGraph == false) {
//       // return CircularProgressIndicator();
//       return Padding(
//           padding: const EdgeInsets.only(top: 20.0),
//           child: BlurredImageWithText());
//     } else if (showGraph == true) {
//       if (showMonthly) {
//         return SizedBox(
//           height: 250,
//           width: 395,
//           child: MonthlyBarGraph(monthlySummary: monthlySummary),
//         );
//       } else {
//         return SizedBox(
//           height: 250,
//           width: 395,
//           child: AnnualBarGraph(annualSummary: annualSummary),
//         );
//       }
//     }
//     return Container(); // Render an empty container if showGraph is false
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TopBar(),
//       bottomNavigationBar: BottomNav(
//         currentIndex: _currentIndex,
//         onIndexChanged: _onIndexChanged,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                 top: 20.0,
//                 bottom: 10.0,
//                 left: 20.0,
//               ),
//               child: Text(
//                 'Hi ${userName ?? '...'}!',
//                 style: const TextStyle(
//                   fontSize: 25,
//                   color: Color(0xFF6EA67C),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10.0),
//               child: _buildGraphWidget(),
//             ),
//             if (showGraph == true) // Display graph if showGraph is true
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 80.0),
//                   child: ToggleButtons(
//                     isSelected: [showMonthly, !showMonthly],
//                     onPressed: _toggleGraph,
//                     selectedColor: const Color.fromRGBO(110, 166, 124, 1),
//                     fillColor: const Color.fromRGBO(110, 166, 124, 0.2),
//                     splashColor: const Color.fromRGBO(110, 166, 124, 0.3),
//                     children: const [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         child: Text('monthly costs'),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         child: Text('annual costs'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             // if (showGraph ==
//             //     false) // Display blurred image if showGraph is false
//             //   Padding(
//             //     padding: const EdgeInsets.only(top: 20.0),
//             //     child: BlurredImageWithText(),
//             //   ),
//             Padding(
//               padding: const EdgeInsets.only(top: 50.0),
//               child: CategoriesList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onIndexChanged(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
// }
