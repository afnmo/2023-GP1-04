import 'package:flutter/material.dart';
import 'package:gp91/components/constants.dart';
import 'package:gp91/login/components/text_field_container.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String inputType;
  final bool password;

  const RoundedInputField({
    super.key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    required this.inputType,
    this.password = false,
  });

  @override
  State<StatefulWidget> createState() => _FormScreenState();
}

class _FormScreenState extends State<RoundedInputField> {
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      // It can be an email field, name field، or password field
      child: TextFormField(
        obscureText: widget.password == true ? true : false,
        onChanged: widget.onChanged,
        validator: (value) {
          if (widget.inputType == "name") {
            if (value!.length < 3) {
              return "Name Should be at least 3 characters";
            } else if (value.isEmpty) {
              return "Please enter your name";
            } else {
              return null;
            }
          } else if (widget.inputType == "email") {
            RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            final isEmailValid = emailRegex.hasMatch(value ?? '');
            if (!isEmailValid) {
              return "Please enter a valid email";
            } else if (value!.isEmpty) {
              return "Please enter your email";
            } else {
              return null;
            }
          } else if (widget.inputType == "password") {
            if (value!.isEmpty) {
              return "Please enter your password";
            } else {
              return null;
            }
          } else if (widget.inputType == "confirmPassword") {
            if (value!.isEmpty) {
              return "Please re-enter your password";
            } else {
              return null;
            }
          }
          return null;
        },
        keyboardType:
            widget.inputType == "email" ? TextInputType.emailAddress : null,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: 'NanumGothic',
          ),
          icon: Icon(
            widget.icon,
            color: primaryColor,
          ),
          suffixIcon: widget.inputType == "password"
              ? const Icon(
                  Icons.visibility,
                  color: primaryColor,
                )
              : null,
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
