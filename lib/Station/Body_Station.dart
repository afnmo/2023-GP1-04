import 'package:flutter/material.dart';
import 'package:gp91/components/constants.dart';
import 'StationList.dart';

class Body_Station extends StatelessWidget {
  const Body_Station({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6EA67C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Find stations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // it enables scrolling on small device
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: 15,
          ),
          // Header(size: size),
          Station_list(),
        ]),
      ),
    );
  }
}
