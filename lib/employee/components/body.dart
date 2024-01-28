import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/employee/next_sprint.dart';
import 'package:gp91/employee/components/background.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/firebase_auth/emp_repository/auth_repository.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:gp91/login/components/text_field_container.dart';
import 'package:gp91/login/forgot_password/forgot_password_mail.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormScreenState();
}

class _FormScreenState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _auth = AuthRepository();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

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
              // Space at the top of the form
              SizedBox(height: size.height * 0.1),
              // Title text for the login form
              const Text(
                "Login For Employee",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              // Space between title and logo
              SizedBox(height: size.height * 0.03),
              // Logo image
              Image.asset(
                "assets/images/logo_no_bkg.png",
                width: size.width,
                height: size.height * 0.3,
              ),
              // Container for the email input field
              TextFieldContainer(
                child: TextFormField(
                  controller: _emailController,
                  onChanged: (value) {},
                  validator: (value) {
                    // Validate email format
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
                    hintStyle: TextStyle(fontFamily: 'NanumGothic'),
                    icon: Icon(Icons.email, color: primaryColor),
                    hintText: "Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
              // Container for the password input field
              TextFieldContainer(
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  onChanged: (value) {},
                  validator: (value) {
                    // Validate password presence
                    if (value!.isEmpty) {
                      return "Please enter your password";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontFamily: 'NanumGothic'),
                    icon: const Icon(Icons.lock, color: primaryColor),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: primaryColor,
                      ),
                    ),
                    hintText: "Password",
                    border: InputBorder.none,
                  ),
                ),
              ),
              // Container for "Forgot Password?" link
              // Container(
              //   margin: const EdgeInsets.only(right: 30),
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: TextButton(
              //       onPressed: () {
              //         // Navigate to the forgot password screen
              //         Get.to(() => ForgotPasswordMailScreen());
              //       },
              //       child: const Text(
              //         "Forgot Password?",
              //         style: TextStyle(
              //           color: primaryColor,
              //           fontFamily: 'NanumGothic',
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Space between "Forgot Password?" link and login button
              SizedBox(height: size.height * 0.01),
              // Rounded login button
              RoundedButton(
                text: "LOGIN",
                press: () {
                  // Validate form before attempting login
                  if (_formKey.currentState?.validate() == true) {
                    print("WOOOOORKED!!");
                    // Attempt to sign in
                    _signIn();
                  } else {
                    print("did not work");
                  }
                },
              ),
              // Space below the login button
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle the sign-in process
  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Show a loading dialog while signing in
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Hash the entered password
      String hashedPassword = hashPassword(password);

      // Check if the employee is terminated
      bool isTerminated =
          await _auth.isEmployeeTerminated(email, hashedPassword);

      // Check if the employee is terminated or not
      if (isTerminated) {
        Get.back(); // Close the loading dialog
        // Display terminated message
        Get.snackbar(
          "Terminated!",
          "You are terminated. Please contact the administrator.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      } else {
        // Check if the email and password match the data in the database
        bool isValidEmployee =
            await _auth.validateEmployeeCredentials(email, hashedPassword);

        Get.back(); // Close the loading dialog

        if (isValidEmployee) {
          print("Employee is successfully logged in");
          // Navigate to the next screen
          Get.to(() => const NextSprint());

          // Clear the input fields
          _emailController.clear();
          _passwordController.clear();
        } else {
          // Display incorrect credentials message
          Get.snackbar(
            "Incorrect Credentials",
            "Incorrect email or password",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      Get.back(); // Close the loading dialog
      // Show a generic error message if an exception occurs
      Get.snackbar(
        "Error",
        "An error occurred. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // Function to hash the provided password using SHA-256 algorithm
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }
}
