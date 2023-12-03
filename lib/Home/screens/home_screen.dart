import 'package:gp91/Home/components/bar_graph/monthly_bar_graph.dart';
import 'package:gp91/Home/components/bar_graph/annual_bar_graph.dart';
import 'package:gp91/Home/components/bar_graph/get_expenses.dart';
import 'package:gp91/Home/components/categories_list.dart';
import 'package:gp91/Home/components/check_car.dart';
import 'package:gp91/home/components/top_bar.dart';
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
  List<double> monthlySummary = [];
  List<double> annualSummary = [];
  bool?
      showGraph; // DECIDES WHETHER TO SHOW THE GRAPH OR THE BLURRED PROMPT TO ADD A CAR
  bool showMonthly = true; // THE DEFAULT IN THE MONTHLY GRAPH
  int _currentIndex = 2; // BOTTOM NAV INDEX SO THE DEFAULT IS HOME

// WHEN BOTTOM NAV INDEX CHANGE THE PAGE WILL CHANGE
  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    //GET THE BILLS
    final QuerySnapshot billsStream =
        await FirebaseFirestore.instance.collection('Bills').get();
    //GET THE USER NAME
    userName = await getUserName.getUserName();
    // CHECK IF A CAR EXISTS TO DECIDE IF YOU NEED TO SHOW GRAPH
    showGraph = await checkCarExists();
    // if (kDebugMode) {
    //   print('User Name: $UserName');
    // } // this is to test
    GetExpenses getExpenses = GetExpenses(billsDocuments: billsStream);
    //GET THE MONTHLY EXPENSES
    List<double> amounts = await getExpenses.getMontlhyAmounts();
    //print(amounts);
    // GET THE ANNUAL EXPENSES
    List<double> amounts2 = await getExpenses.getAnnualAmounts();
    if (mounted) {
      setState(() {
        monthlySummary = amounts;
        annualSummary = amounts2;
      });
    }
  }

  void _toggleGraph(int index) {
    setState(() {
      showMonthly = index ==
          0; // Set showGraph based on index (0: monthly costs, 1: annual costs)
    });
  }

// BUILD THE GRAPH BASED ON THE SHOW GRAPH
  Widget _buildGraphWidget() {
    if (showGraph == null) {
      return const CircularProgressIndicator();
    } else if (showGraph == true) {
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
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
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
            if (showGraph == true) //SHOW THE GRAPH
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 80.0),
                  // SHOW THE TOGGLE BUTTONS THAT TOGGLE BETWEEN MONTHLY AND ANUALL GRAPHS
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
            if (showGraph ==
                false) // IF THERE IS NO CAR PROMPT THE USER TO ADD A CAR TO START CALCULATING THEIR EXPENSES
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: BlurredImageWithText(),
              ),
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: CategoriesList(),
            ),
          ],
        ),
      ),
    );
  }
}
