import 'package:flutter/material.dart';
import 'package:gp91/a_i_want_to_delete_them/custom_snack_bar_content.dart';

class FlashMessageScreen extends StatelessWidget {
  const FlashMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: CustomSnackBarContent(
                  errorTitle: "Oh snap!",
                  errorBody: "Flutter default snackbar is showing",
                  snackBarcolor: Color(0xffB00020),
                  iconColor: Color(0xff801336),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            );
          },
          child: const Text(
            "Show Message",
          ),
        ),
      ),
    );
  }
}
