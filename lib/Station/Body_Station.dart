import 'package:flutter/material.dart';
import 'package:gp91/components/constants.dart';
import 'StationList.dart';

class Body_Station extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // It will provie us total height  and width of our screen

    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small device
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Header(size: size),
        Station_list(),
      ]),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      //it will cover 20% of our total height
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              // bottom: 36 + kDefaultPadding,
              top: 20,
            ),
            height: size.height * 0.2 - 27,
            decoration: const BoxDecoration(
              // color: kPrimaryColor,
              color: Color(0xFF6EA67C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: <Widget>[
                const Text(
                  'Find Stations!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32),
                ),
                // Spacer(),
                Image.asset(
                  "assets/images/logo.png",
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: 54,
            ),
          ),
        ],
      ),
    );
  }
}
