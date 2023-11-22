import 'package:flutter/material.dart';
import 'package:gp91/components/constants.dart';

class customShapeBorder extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  customShapeBorder(this.text);

  @override
  Size get preferredSize => Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    double width = text.length == 4 ? 100.0 : 55.0;
    return Container(
      height: 150,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              top: 20,
            ),
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFF6EA67C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 32, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: width),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                SizedBox(width: 10),
                Image.asset(
                  "assets/images/logo.png",
                  height: 60,
                  width: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
