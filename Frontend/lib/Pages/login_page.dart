// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/Api%20Services/api_services.dart';
import 'package:to_do/Pages/home_page.dart';
import 'package:to_do/Widgets/button.dart';
import 'package:to_do/Widgets/colors.dart';
import 'package:to_do/Widgets/text_field.dart';
import 'package:to_do/Pages/register_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text editing controllers for email and password fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Shared preferences instance
  late SharedPreferences sharedPref;

  //Error text for empty fields
  bool errorText = false;

  //Login user function to login user and save token in shared preferences
  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Login user
      var loginBody = {
        'email': emailController.text,
        'password': passwordController.text,
      };
      var response = await http.post(
        Uri.parse(login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginBody),
      );
      if (response.statusCode == 200) {
        var token = jsonDecode(response.body)['token'];
        // Initialize shared preferences and save token
        initSharedPref();
        sharedPref.setString('token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logged in successfully!',
              style: TextStyle(
                color: blue,
              ),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: grey,
          ),
        );

        // Navigate to HomePage after token is saved
        Get.to(
          () => HomePage(
            token: token,
          ),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 500),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log in: ${response.body}'),
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

  //Init state function to initialize shared preferences
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  //Init shared preferences function to initialize shared preferences
  void initSharedPref() async {
    sharedPref = await SharedPreferences.getInstance();
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
                "Let's \nSign in ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 50),
              Column(
                children: [
                  Text(
                    'Stay organized and achieve more every day. \nLog in to manage your tasks effortlessly!',
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
                    onTap: () {
                      loginUser();
                    },
                    child: MyButton(
                      text: 'Sign in',
                    ),
                  ),
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(
                            () => RegisterPage(
                              onTap: () {},
                            ),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: blue),
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
