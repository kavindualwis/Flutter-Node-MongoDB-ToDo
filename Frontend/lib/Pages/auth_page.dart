// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/Pages/home_page.dart';
import 'package:to_do/Pages/login_page.dart';
import 'package:to_do/Pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //initially, show login page
  bool showLoginPage = true;

  //check if user is logged in or not and navigate to the appropriate page
  void checkIfLoggedIn(BuildContext context) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    //get the token from shared preferences and check if it is expired
    String? token = sharedPref.getString('token');

    //if token is not null and not expired, navigate to home page else navigate to login page
    if (token != null && !JwtDecoder.isExpired(token)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            token: token,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            onTap: () {},
          ),
        ),
      );
    }
  }

  //toggle between login and register pages when the user taps on the text
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  //check if user is logged in when the page is loaded and navigate to the appropriate page
  @override
  void initState() {
    super.initState();
    checkIfLoggedIn(context);
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
