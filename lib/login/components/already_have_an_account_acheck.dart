import 'package:flutter/material.dart';
import 'package:gp91/components/constants.dart';

class AlreadyHaveAnAcoountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAnAcoountCheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don't have an account? " : "Already have an account? ",
          style: const TextStyle(
            color: primaryColor,
            fontFamily: 'NanumGothic',
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: const TextStyle(
              color: primaryColor,
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
