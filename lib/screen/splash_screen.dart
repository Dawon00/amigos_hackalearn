import 'dart:async';

import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 5),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: screenHeight * 0.384375),
          Image.asset(
            'assets/icons8-돈-상자.gif',
            width: screenWidth * 0.616666,
            height: screenHeight * 0.0859375,
          ),
          Image.asset(
            'assets/절약하는 친구들.gif',
            width: screenWidth * 0.616666,
            height: screenHeight * 0.0859375,
          ),
          const Expanded(child: SizedBox()),
          Align(
            child: Text(
              "© Copyright 2022, 아미고스(AMIGOS)",
              style: TextStyle(
                fontSize: screenWidth * (14 / 360),
                color: const Color.fromARGB(153, 0, 0, 0),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.0625,
          ),
        ],
      ),
    );
  }
}
