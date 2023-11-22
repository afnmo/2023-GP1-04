import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/firebase_auth/user_model.dart';
import 'package:gp91/firebase_auth/user_repository/auth_repository.dart';
import 'package:gp91/login/components/already_have_an_account_acheck.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:gp91/login/components/text_field_container.dart';
import 'package:gp91/login/login.dart';
import 'package:gp91/signup/components/background.dart';

class Body extends StatefulWidget {
  final Widget child;
  const Body({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _FormScreenState();
}

class _FormScreenState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  // final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  // final SignUpController _signUpController = SignUpController();

  // for firebase
  final AuthRepository _authRepository = AuthRepository();

  // controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // for the password visiability
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  final digitPattern = RegExp(r'(?=.*\d)');
  final lowercasePattern = RegExp(r'(?=.*[a-z])');
  final uppercasePattern = RegExp(r'(?=.*[A-Z])');
  final specialCharPattern = RegExp(r'(?=.*[@#$%^&+=])');

  String? validatePassword(String pass) {
    String password = pass.trim();

    if (password.isEmpty ||
        password.length < 8 ||
        !digitPattern.hasMatch(password) ||
        !lowercasePattern.hasMatch(password) ||
        !uppercasePattern.hasMatch(password) ||
        !specialCharPattern.hasMatch(password)) {
      return 'Password should include at least one digit, one lowercase and one uppercase letter, and one special character, with a minimum of 8 characters.';
    }

    return null; // Password is valid
  }

  // dispose the controllers
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Image.asset(
                  "assets/images/logo_no_bkg.png",
                  width: size.width,
                  height: size.height * 0.3,
                ),

                // name               nameInput,
                TextFieldContainer(
                  child: TextFormField(
                    controller: _nameController,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value!.length < 3) {
                        return "Name Should be at least 3 characters";
                      } else if (value.isEmpty) {
                        return "Please enter your name";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontFamily: 'NanumGothic',
                      ),
                      icon: Icon(
                        Icons.person,
                        color: primaryColor,
                      ),
                      hintText: "Name",
                      border: InputBorder.none,
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                // email               emailInput,
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
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),

                // password              passwordInput,
                TextFieldContainer(
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText1,
                    onChanged: (value) {},
                    validator: (value) {
                      return validatePassword(value!);
                    },
                    decoration: InputDecoration(
                      errorMaxLines: 4,
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
                            _obscureText1 = !_obscureText1;
                          });
                        },
                        child: Icon(
                          _obscureText1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: primaryColor,
                        ),
                      ),
                      hintText: "Password",
                      border: InputBorder.none,
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                // confirm              confirmPasswordInput,
                TextFieldContainer(
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureText2,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please re-enter your password";
                      } else if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        return "Passwords don't match";
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
                            _obscureText2 = !_obscureText2;
                          });
                        },
                        child: Icon(
                          _obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: primaryColor,
                        ),
                      ),
                      hintText: "Confirm password",
                      border: InputBorder.none,
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),

                // SIGN UP BUTTON
                RoundedButton(
                  text: "SIGN UP",
                  // Go to the home page
                  press: () {
                    if (_formKey.currentState?.validate() == true) {
                      print("WOOOOORKED validation!!");

                      final user = UserModel(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      _authRepository.createUserWithEmailAndPassword(user);

                      _nameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                    } else {
                      print("validation did not work");
                    }
                  },
                ),
                AlreadyHaveAnAcoountCheck(
                  login: false,
                  press: () {
                    Get.to(() => const LoginScreen());
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return LoginScreen();
                    //     },
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
