import 'package:flutter/material.dart';

class TextFeild extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final Icon icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool errorText;

  const TextFeild({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.icon,
    required this.obscureText,
    required this.keyboardType,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    const outlinedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF757575)),
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );
    return Form(
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black, fontSize: 18),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: icon,
          errorText: errorText ? 'Value Can\'t Be Empty' : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          border: outlinedBorder,
          enabledBorder: outlinedBorder,
          focusedBorder: outlinedBorder.copyWith(
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }
}
