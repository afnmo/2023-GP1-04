import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:gp91/login/components/text_field_container.dart';
import 'package:gp91/a_i_want_to_delete_them/otp_screen.dart';

class ForgotPasswordMailScreen extends StatefulWidget {
  ForgotPasswordMailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordMailScreenState();
}

class _ForgotPasswordMailScreenState extends State<ForgotPasswordMailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Check your email"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/forgot1.png",
                  width: size.width * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/forgot2.png",
                  width: size.width * 0.35,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.09,
                    ),
                    Image.asset(
                      "assets/images/forgot_256.png",
                      width: size.width * 0.4,
                      height: size.height * 0.3,
                      // color: mainColorDark,
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30), // Add left and right padding
                      child: Text(
                        "Enter the email address associated with your account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30), // Add left and right padding
                      child: Text(
                        "We will email you a link to reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    TextFieldContainer(
                      child: TextFormField(
                        controller: _emailController,
                        onChanged: (value) {},
                        validator: (value) {
                          RegExp emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          final isEmailValid = emailRegex.hasMatch(value ?? '');
                          if (!isEmailValid) {
                            return "Please enter a valid email";
                          } else if (value!.isEmpty) {
                            return "Please enter your email";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            fontFamily: 'NanumGothic',
                          ),
                          icon: Icon(
                            Icons.email,
                            color: primaryColor,
                          ),
                          hintText: "Email",
                          border: InputBorder.none,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    RoundedButton(
                      text: "Reset Password",
                      press: () {
                        if (_formKey.currentState?.validate() == true) {
                          print("validation worked in forogt pass!!");
                          passwordReset();
                          // Get.to(() => const OTPScreen());
                        } else {
                          print("did not work forgot pass");
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 30,
                left: 30,
                child: BackButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
