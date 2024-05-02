import 'package:flutter/material.dart';
import 'package:gp91/settings/settings_page.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                right: 0.0, left: 0.0), // Adjust the left padding as needed
            child: Image.asset(
              'assets/images/logo_no_bkg.png',
              width: 60,
            ),
          ),
          // const SizedBox(width: 8),
          const Text(
            '91',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF6EA67C),
            ),
          ),
        ],
      ),
      actions: [],
    );
  }
}
