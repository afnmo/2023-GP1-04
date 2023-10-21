import 'package:flutter/material.dart';
import 'package:gp91/components/constants.dart';
//import 'package:../components/constants.dart';
import 'Body_Station.dart';

class Station extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
      ),
      body: Body_Station(),
    );
  }
}
