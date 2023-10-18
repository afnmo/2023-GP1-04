import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // Set the background color to white
      elevation: 0, // Remove the shadow
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo_no_bkg.png',
            width: 40,
          ),
          SizedBox(width: 8),
          Text(
            '91',
            style: TextStyle(
                fontSize: 20, color: Color(0xFF6EA67C)), // Set the text color
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications,
              color: Color(0xFF6EA67C)), // Set the icon color
          onPressed: () {
            // Add your notification icon onPressed logic here
          },
        ),
      ],
    );
  }
}
