import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/home/screens/home_screen.dart';
import 'package:gp91/a_i_want_to_delete_them/firebase_auth_services.dart';
import 'package:gp91/firebase_auth/user_repository/auth_repository.dart';
import 'package:gp91/login/components/already_have_an_account_acheck.dart';
import 'package:gp91/login/components/background.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:gp91/login/components/text_field_container.dart';
import 'package:gp91/login/forgot_password/forgot_password_mail.dart';
import 'package:gp91/a_i_want_to_delete_them/logout.dart';
import 'package:gp91/signup/signup.dart';

// from StatelessWidget to stateful
class Body extends StatefulWidget {
  Body({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _FormScreenState();
}

class _FormScreenState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _auth = AuthRepository();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.1,
              ),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Image.asset(
                "assets/images/logo_no_bkg.png",
                width: size.width,
                height: size.height * 0.3,
              ),

//              emailInput,
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
              // passwordInput,
              TextFieldContainer(
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(
                      fontFamily: 'NanumGothic',
                    ),
                    icon: const Icon(
                      Icons.lock,
                      color: primaryColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: primaryColor,
                      ),
                    ),
                    hintText: "Password",
                    border: InputBorder.none,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),

              Container(
                margin: const EdgeInsets.only(right: 30),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => ForgotPasswordMailScreen());
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'NanumGothic',
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              RoundedButton(
                text: "LOGIN",
                // Go to the home page
                press: () {
                  //passwordInput.formKey.currentState?.validate() == true)
                  if (_formKey.currentState?.validate() == true) {
                    print("WOOOOORKED!!");
                    _signIn();
                  } else {
                    print("did not work");
                  }
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              AlreadyHaveAnAcoountCheck(
                press: () {
                  Get.to(() => SignUpScreen());
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return SignUpScreen();
                  //     },
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // try {
    User? user = await _auth.signInWithEmailAndPassword(email, password);
    print("user: " + user.toString());
    Get.back();

    if (user != null) {
      print("User is successfully logged in");
      Get.to(() => HomeScreen());

      // Clear the input fields
      _emailController.clear();
      _passwordController.clear();
    } else {
      Get.snackbar(
        "Oops!",
        "Incorrect email or password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
    //   } else {
    //     print("User login failed");
    //     Get.snackbar(
    //       "Oops!",
    //       "It seems like there's no account associated with this email address. Please double-check your email or sign up to create a new account",
    //       snackPosition: SnackPosition.BOTTOM,
    //       backgroundColor: Colors.redAccent.withOpacity(0.1),
    //       colorText: Colors.red,
    //     );
    //   }
    // } catch (e) {
    //   print("Error during login: $e");
    //   Get.back();

    //   if (e is FirebaseAuthException) {
    //     if (e.code == 'user-not-found') {
    //       // User not found - Display the appropriate error message
    //       Get.snackbar(
    //         "Oops!",
    //         "It seems like there's no account associated with this email address. Please double-check your email or sign up to create a new account",
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.redAccent.withOpacity(0.1),
    //         colorText: Colors.red,
    //       );
    //     } else if (e.code == 'wrong-password') {
    //       // Incorrect password - Display the incorrect password message
    //       Get.snackbar(
    //         "Oops!",
    //         "Incorrect Password. Please try again",
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.redAccent.withOpacity(0.1),
    //         colorText: Colors.red,
    //       );
    //     } else {
    //       // Handle other error codes as needed
    //       // You can add more specific error handling for other cases if necessary
    //       Get.snackbar(
    //         "Oops!",
    //         "An error occurred during sign-in. Please try again later",
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.redAccent.withOpacity(0.1),
    //         colorText: Colors.red,
    //       );
    //     }
    //   }
    // }

    // } catch (e) {
    //   print("Error during login: $e");
    //   Get.back();

    //   if (e is FirebaseAuthException) {
    //     if (e.code == 'user-not-found') {
    //       // User not found - Display the snack bar
    //       Get.snackbar(
    //         "Oops!",
    //         "It seems like there's no account associated with this email address. Please double-check your email or sign up to create a new account",
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.redAccent.withOpacity(0.1),
    //         colorText: Colors.red,
    //       );
    //     } else {
    //       Get.snackbar(
    //         "Oops!",
    //         "Incorrect Password. Please try again",
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.redAccent.withOpacity(0.1),
    //         colorText: Colors.red,
    //       );
    //     }
    //   }
    // }
  }
}
