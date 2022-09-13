import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/HomePage/HomePage.dart';
import 'package:thesocial/screens/LandingPage/LandingServices.dart';
import 'package:thesocial/screens/LandingPage/LandingUtils.dart';
import 'package:thesocial/services/Authentication.dart';

class LandingHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'),
        ),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      left: 20,
      top: 460,
      child: Container(
        width: 170,
        child: RichText(
          text: TextSpan(
              text: 'Are ',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'You ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.blueColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Social ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.blueColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: 640,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Container(
                width: 80,
                height: 40,
                child: Icon(
                  EvaIcons.emailOutline,
                  color: constantColors.yellowColor,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.yellowColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              onTap: () {
                emailAuthSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 740,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "By Countinuing you agree theSocials's Terms of",
                style: TextStyle(color: constantColors.greyColor),
              ),
              Text(
                "Services & Privacy Policy",
                style: TextStyle(color: constantColors.greyColor),
              )
            ],
          ),
        ));
  }

  Future emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                // Provider.of<LandingServices>(context, listen: false)
                //     .passwordLessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Provider.of<LandingServices>(context, listen: false)
                            .loginSheet(context);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.redColor,
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false)
                            .userAvatar = null;
                        Provider.of<LandingServices>(context, listen: false)
                            .signInSheet(context);
                        Provider.of<LandingServices>(context, listen: false)
                            .avatarSelectOptions(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
