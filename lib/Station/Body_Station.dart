import 'package:flutter/material.dart';
import 'package:gp91/station/station_list.dart';

// Body widget for the station screen
class BodyStation extends StatelessWidget {
  // Constructor for BodyStation widget
  const BodyStation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold widget for the station screen
    return Scaffold(
      appBar: AppBar(
        // App bar styling
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

      // Body with a SingleChildScrollView to enable scrolling on small devices
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            // Station list widget
            StationList(),
          ],
        ),
      ),
    );
  }
}
