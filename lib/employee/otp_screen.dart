import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gp91/employee/next_sprint.dart';
import 'package:email_otp/email_otp.dart';
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
  const OtpScreen({Key? key, required this.myauth}) : super(key: key);

  final EmailOTP myauth;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  // Function to resend the OTP code
  Future<void> resendCode() async {
    if (await widget.myauth.sendOTP() == true) {
      Get.snackbar(
        "New OTP Send",
        "Check your email ",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF2BB671),
        colorText: Color(0xFF2BB671),
      );
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops, OTP resend failed"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Background(
        child: Scaffold(
          body: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Enter PIN",
                style: TextStyle(fontSize: 40),
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
                height: 40,
              ),

              const SizedBox(
                height: 40,
              ),
              Container(
                width: 150, // Set your preferred width
                height: 50, // Set your preferred height
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(25), // Adjust the radius as needed
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (await widget.myauth.verifyOTP(
                            otp: otp1Controller.text +
                                otp2Controller.text +
                                otp3Controller.text +
                                otp4Controller.text) ==
                        true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NextSprint()),
                      );
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
                    primary: Color.fromARGB(
                        255, 146, 158, 145), // Set your preferred button color
                  ),
                  child: SizedBox(
                    width: 150, // Set your preferred width
                    height: 50, // Set your preferred height
                    child: Center(
                      child: const Text(
                        "Confirm",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              // Button to resend the OTP code
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () => resendCode(),
                child: Text(
                  "Resend the code",
                  style: TextStyle(
                    color: Color(0xFF81A5A7),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
