import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/login/components/rounded_button.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "CO\nDE",
                style: TextStyle(
                  fontSize: 80,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                "Verification".toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              const Text(
                //the email user passed in the prev screen
                "Enter the verification code sent at " + "afnan@gmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                // borderColor: Color(0xFF512DA8),
                // //set to true to show as box or false to show as dash
                // showFieldAsBox: true,
                // //runs when a code is typed in
                onCodeChanged: (String code) {
                  // get each value
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      });
                }, // end onSubmit
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              RoundedButton(
                text: "Next",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
