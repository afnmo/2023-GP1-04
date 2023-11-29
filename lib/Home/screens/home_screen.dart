// import 'package:gp91/Home/components/barGraph/bar_graph.dart';
// import 'package:gp91/Home/components/barGraph/stream_builder.dart';
// import 'package:gp91/Home/components/categories_list.dart';
// import 'package:gp91/home/components/topBar.dart';
// import 'package:flutter/material.dart';
// import 'package:gp91/components/bottom_nav.dart';
// import 'package:gp91/home/components/blurred_image_with_text.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   // _HomeScreenState createState() => _HomeScreenState();
//   State<StatefulWidget> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<double> monthlySummary = [
//     100.0,
//     800.0,
//     300.0,
//     500.0,
//   ];
//   int _currentIndex = 2;
//   Stream<QuerySnapshot> _billsStream =
//       FirebaseFirestore.instance.collection('Bills').snapshots();

//   void _onIndexChanged(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
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
//           children: [
//             // Padding(
//             //   padding: const EdgeInsets.only(top: 20.0, left: 15.0),
//             //   child: Align(
//             //     alignment: Alignment.centerLeft,
//             //     child: Column(
//             //       crossAxisAlignment: CrossAxisAlignment.start,
//             //       children: [
//             //         const Text(
//             //           'Your Journey,',
//             //           style: TextStyle(
//             //             fontWeight: FontWeight.w900,
//             //             fontStyle: FontStyle.italic,
//             //             fontFamily: 'Open Sans',
//             //             fontSize: 40,
//             //           ),
//             //         ),
//             //         const Text(
//             //           'Our Priority',
//             //           style: TextStyle(
//             //             fontWeight: FontWeight.w900,
//             //             fontStyle: FontStyle.italic,
//             //             fontFamily: 'Open Sans',
//             //             fontSize: 40,
//             //           ),
//             //         ),
//             //         RichText(
//             //           text: const TextSpan(
//             //             style: TextStyle(
//             //               fontWeight: FontWeight.w900,
//             //               fontStyle: FontStyle.italic,
//             //               fontFamily: 'Open Sans',
//             //               fontSize: 40,
//             //               color: Colors.black,
//             //             ),
//             //             children: [
//             //               TextSpan(
//             //                 text: 'Fueling',
//             //                 style: TextStyle(
//             //                     color: Color(0xFF6EA67C)), // Change the color
//             //               ),
//             //               TextSpan(
//             //                 text: ' Made Smart.',
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             Padding(
//               padding: const EdgeInsets.only(top: 35.0),
//               //child: BlurredImageWithText(),
//               child: SizedBox(
//                 height: 100,
//                 child: MyBarGraph(monthlySummary: monthlySummary),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 10.0),
//               //child: StreamBuilderExample(stream: _billsStream),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 10.0),
//               child: CategoriesListMallika1(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
////////////////////////////////////////////////////////////////////////////////////////////
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gp91/Home/components/barGraph/bar_data.dart';
// import 'package:gp91/Home/components/barGraph/bar_graph.dart';
// import 'package:gp91/components/bottom_nav.dart';
// import 'package:gp91/home/components/categories_list.dart';
// import 'package:gp91/home/components/topBar.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 2;
//   Stream<QuerySnapshot> _billsStream =
//       FirebaseFirestore.instance.collection('Bills').snapshots();

//   void _onIndexChanged(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
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
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 35.0),
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _billsStream,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }

//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }

//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Text('No data available');
//                   }

//                   final monthlySummary = snapshot.data!.docs
//                       .map((doc) => (doc['amount'] as int?)?.toDouble())
//                       .whereType<double>()
//                       .toList();

//                   return SizedBox(
//                     height: 300,
//                     child: MyBarGraph(monthlySummary: monthlySummary),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 10.0),
//               child: CategoriesListMallika1(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
/////////////////////////////////////////////////////////////////////////
import 'package:flutter/foundation.dart';
import 'package:gp91/Home/components/annualGraph/aStream_builder.dart';
import 'package:gp91/Home/components/barGraph/bar_graph.dart';
import 'package:gp91/Home/components/annualGraph/aBar_graph.dart';
import 'package:gp91/Home/components/barGraph/stream_builder.dart';
import 'package:gp91/Home/components/categories_list.dart';
import 'package:gp91/Home/components/checkCar.dart';
import 'package:gp91/home/components/topBar.dart';
import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'package:gp91/home/components/blurred_image_with_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/Home/components/getUserName.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GetUserName getUserName = GetUserName();
  String? UserName;
  List<double> monthlySummary = [];
  List<double> annualSummary = [];
  bool? showGraph;
  bool showMonthly = true;
  int _currentIndex = 2;
  Stream<QuerySnapshot> _billsStream =
      FirebaseFirestore.instance.collection('Bills').snapshots();
  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMonthlySummary();
  }

  Future<void> _fetchMonthlySummary() async {
    // Use the getUserName
    UserName = await getUserName.getUserName();
    showGraph = await checkCarExists();
    // if (kDebugMode) {
    //   print('User Name: $UserName');
    // } // this is to test
    StreamBuilderExample example = StreamBuilderExample(stream: _billsStream);
    List<double> amounts = await example.getAmounts();
    StreamBuilderAnnual example2 = StreamBuilderAnnual(stream: _billsStream);
    List<double> amounts2 = await example2.getAnnualAmounts();

    setState(() {
      monthlySummary = amounts;
      annualSummary = amounts2;
    });
  }

  void _toggleGraph(int index) {
    setState(() {
      showMonthly = index ==
          0; // Set showGraph based on index (0: monthly costs, 1: annual costs)
    });
  }

  Widget _buildGraphWidget() {
    if (showGraph == null) {
      return CircularProgressIndicator();
    } else if (showGraph == true) {
      if (showMonthly) {
        return SizedBox(
          height: 250,
          child: MyBarGraph(monthlySummary: monthlySummary),
        );
      } else {
        return SizedBox(
          height: 250,
          child: annualBarGraph(annualSummary: annualSummary),
        );
      }
    }
    return Container();
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
                'Hi ${UserName ?? '...'}!',
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF6EA67C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // if (showGraph == null) CircularProgressIndicator(),
            if (showGraph == true)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 80.0),
                  child: ToggleButtons(
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
                    isSelected: [showMonthly, !showMonthly],
                    onPressed: _toggleGraph,
                    selectedColor: Color.fromRGBO(110, 166, 124, 1),
                    fillColor: Color.fromRGBO(110, 166, 124, 0.2),
                    splashColor: Color.fromRGBO(110, 166, 124, 0.3),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: _buildGraphWidget(),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: SizedBox(
            //     height: 250,
            //     child: annualBarGraph(annualSummary: annualSummary),
            //   ),
            // ),
            if (showGraph == false)
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: BlurredImageWithText(),
              ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: CategoriesListMallika1(),
            ),
          ],
        ),
      ),
    );
  }
}
