// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/Api%20Services/api_services.dart';
import 'package:to_do/Widgets/button.dart';
import 'package:to_do/Pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:to_do/Widgets/colors.dart';

import '../Widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Controllers for email and password text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Error text for text fields
  bool errorText = false;

  //Function to register user with email and password using API
  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      var response = await http.post(
        Uri.parse(registration),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              onTap: () {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register: ${response.body}'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        errorText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text(
                "Let's \nSign up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 50),

              //Column for text fields and buttons for registration
              Column(
                children: [
                  Text(
                    'Sign up to organize your tasks and boost \nproductivity!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  TextFeild(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    icon: const Icon(Icons.email),
                    controller: emailController,
                    obscureText: false,
                    errorText: errorText,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  TextFeild(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    icon: const Icon(Icons.password),
                    controller: passwordController,
                    obscureText: true,
                    errorText: errorText,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => registerUser(),
                    child: MyButton(
                      text: 'Sign up',
                    ),
                  ),
                  SizedBox(height: 80),

                  //Row for sign in text and button to navigate to login page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(
                            () => LoginPage(
                              onTap: () {},
                            ),
                            transition: Transition.leftToRight,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
