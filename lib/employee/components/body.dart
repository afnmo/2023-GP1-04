import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/employee/components/background.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/employee/otp_screen.dart';
import 'package:gp91/firebase_auth/emp_repository/auth_repository.dart';
import 'package:gp91/login/components/rounded_button.dart';
import 'package:gp91/login/components/text_field_container.dart';
import 'package:email_otp/email_otp.dart';

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

  EmailOTP myauth = EmailOTP();

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

  // bool _obscureText = true;

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

              // Space between "Forgot Password?" link and login button
              SizedBox(height: size.height * 0.01),
              // Rounded login button
              RoundedButton(
                text: "Send Code",
                press: () async {
                  // Check if the employee is terminated
                  var send_email = _emailController.text;
                  bool isValid =
                      await _auth.validateEmployeeCredentials(send_email);
                  if (isValid) {
                    myauth.setConfig(
                        appEmail: "contact@hdevcoder.com",
                        appName: "Email OTP",
                        userEmail: _emailController.text,
                        otpLength: 4,
                        otpType: OTPType.digitsOnly);
                    if (await myauth.sendOTP() == true) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("OTP has been sent"),
                      ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                    myauth: myauth,
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Oops, OTP send failed"),
                      ));
                    }
                  } else {
                    //Get.back(); // Close the loading dialog
                    // Display terminated message
                    Get.snackbar(
                      "Incorrect Email!",
                      "try again aor ask your manager ",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      colorText: Colors.red,
                    );
                    return;
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
}
