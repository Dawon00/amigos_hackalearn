import 'dart:async';

import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
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
    new Future.delayed(
        const Duration(seconds: 5),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.384375),
              Container(
                child: Image.asset(
                  'assets/icons8-돈-상자.gif',
                  width: screenWidth * 0.616666,
                  height: screenHeight * 0.0859375,
                ),
              ),
              Align(
                child: Text("AMIGOS",
                    style: TextStyle(
                      fontSize: screenWidth * (30 / 360),
                      color: Color.fromARGB(153, 0, 0, 0),
                    )),
              ),
              Expanded(child: SizedBox()),
              Align(
                child: Text("© Copyright 2022, 아미고스(AMIGOS)",
                    style: TextStyle(
                      fontSize: screenWidth * (14 / 360),
                      color: Color.fromARGB(153, 0, 0, 0),
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.0625,
              ),
            ],
          ),
        ));
  }
}
