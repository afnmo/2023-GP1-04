import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:email_otp/email_otp.dart';
import 'package:gp91/employee/home.dart';
import 'package:gp91/signup/components/background.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);

  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: (' '),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.myauth, required this.userEmail})
      : super(key: key);

  final EmailOTP myauth;
  final String userEmail;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  bool isResendClickable = false; // Change this line
  int timerSeconds = 30;

  // Function to start the timer
  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      if (timerSeconds == 0) {
        setState(() {
          isResendClickable = true;
        });
        timer.cancel();
      } else {
        setState(() {
          timerSeconds--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Start the timer immediately when the page loads
    startTimer();
  }

  // Function to resend the OTP code
  Future<void> resendCode() async {
    if (await widget.myauth.sendOTP() == true) {
      Get.snackbar(
        "New OTP Send",
        "Check your email ",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        // backgroundColor: Color(0xFF2BB671),
        // colorText: Color.fromARGB(255, 248, 249, 249),
      );
      setState(() {
        isResendClickable = false;
        timerSeconds = 30;
      });
      startTimer();
    } else {
      Get.snackbar(
        "Oops!",
        "OTP resend failed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Background(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: SvgPicture.asset(
                    'assets/icons/PIN.svg',
                    width: 250,
                    height: 250,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Enter PIN",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6EA67C)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "We will send in your email\n a PIN code, check your email.",
                  style: TextStyle(
                    color: Color.fromARGB(146, 77, 76, 76),
                    fontSize: 16, // Adjust the font size as needed
                    //fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Otp(
                      otpController: otp1Controller,
                    ),
                    Otp(
                      otpController: otp2Controller,
                    ),
                    Otp(
                      otpController: otp3Controller,
                    ),
                    Otp(
                      otpController: otp4Controller,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check if any of the OTP fields is empty
                      if (otp1Controller.text.isEmpty ||
                          otp2Controller.text.isEmpty ||
                          otp3Controller.text.isEmpty ||
                          otp4Controller.text.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please enter the complete code",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          colorText: Colors.red,
                        );
                        return; // Return to avoid further processing
                      }

                      // Continue with OTP verification
                      if (await widget.myauth.verifyOTP(
                              otp: otp1Controller.text +
                                  otp2Controller.text +
                                  otp3Controller.text +
                                  otp4Controller.text) ==
                          true) {
                        var name =
                            await getEmployeeNameByEmail(widget.userEmail);
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                email: widget.userEmail,
                              ),
                            ),
                          );
                        }
                      } else {
                        Get.snackbar(
                          "Incorrect!",
                          "Try Again ",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          colorText: Colors.red,
                        );
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 146, 158, 145),
                    ),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: Center(
                        child: const Text(
                          "Confirm",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: isResendClickable ? () => resendCode() : null,
                  child: Text(
                    "Resend the code${isResendClickable ? '' : ' ($timerSeconds s)'}",
                    style: TextStyle(
                      color: isResendClickable
                          ? Color.fromARGB(255, 114, 186, 126)
                          : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> getEmployeeNameByEmail(String email) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Station_Employee')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String employeeName = querySnapshot.docs.first['name'];
      return employeeName;
    } else {
      return ''; // Default to empty string
    }
  } catch (e) {
    print('Error fetching employee name: $e');
    return ''; // Default to empty string
  }
}
