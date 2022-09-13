import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/HomePage/HomePage.dart';
import 'package:thesocial/screens/LandingPage/LandingPage.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> setUser() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool("logged") ?? true;
      if (user != null && isLoggedIn) {
        print("dvsv");
        Provider.of<FirebaseOperations>(context, listen: false)
            .fetchUserProfileInfo(context);
        var email = prefs.getString("email");
        var password = prefs.getString("password");
        Provider.of<Authentication>(context, listen: false)
            .logIntoAccount(email, password);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }

  @override
  void initState() {
    setUser().then((data) => {
          if (data)
            {
              Timer(
                Duration(seconds: 2),
                () => Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: HomePage(),
                    type: PageTransitionType.leftToRight,
                    duration: Duration(milliseconds: 500),
                  ),
                ),
              )
            }
          else
            {
              Timer(
                Duration(seconds: 2),
                () => Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: LandingPage(),
                    type: PageTransitionType.leftToRight,
                    duration: Duration(milliseconds: 500),
                  ),
                ),
              )
            }
        });
    super.initState();
  }

  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'The',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                    text: 'Social',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.blueColor,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                    ))
              ]),
        ),
      ),
    );
  }
}
