import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/screens/Profile/ProfileHelpers.dart';
import 'package:thesocial/screens/LandingPage/LandingPage.dart';

class Profile extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: constantColors.blueGreyColor,
          actions: [
            IconButton(
              icon: Icon(
                EvaIcons.logOutOutline,
                size: 30,
                color: constantColors.greenColor,
              ),
              onPressed: () {
                Provider.of<ProfileHelpers>(context, listen: false)
                    .logoutDialog(context);
              },
            )
          ],
          title: RichText(
              text: TextSpan(
                  text: 'My',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: constantColors.whiteColor,
                  ),
                  children: [
                TextSpan(
                    text: 'Profile',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0))
              ])),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 1.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: constantColors.blueGreyColor.withOpacity(0.6)),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(Provider.of<Authentication>(context).getUserUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: [
                        Provider.of<ProfileHelpers>(context, listen: false)
                            .headerProfile(context, snapshot),
                        Provider.of<ProfileHelpers>(context, listen: false)
                            .divider(context),
                        SizedBox(height: 10),
                        Provider.of<ProfileHelpers>(context, listen: false)
                            .footerProfile(
                          context,
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
