import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
          ), //add logo
          const SizedBox(width: 8),
          const Text(
            '91',
            style: TextStyle(
                fontSize: 20, color: Color(0xFF6EA67C)), // Set the text color
          ), //app name in the top bar
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications,
              color: Color(0xFF6EA67C)), // Set the icon color
          onPressed: () {
            // Add your notification icon onPressed logic here
          },
        ),
      ],
    );
  }
}
