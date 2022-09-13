import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/AltProfile/AltProfileHelpers.dart';
import 'package:thesocial/screens/HomePage/HomePage.dart';

class AltProfile extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  final String userUid;
  AltProfile({@required this.userUid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constantColors.blueGreyColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.leftToRight));
          },
        ),
        title: RichText(
            text: TextSpan(
                text: 'The',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: constantColors.whiteColor,
                ),
                children: [
              TextSpan(
                text: 'Social',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              )
            ])),
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.whiteColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomePage(), type: PageTransitionType.leftToRight));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.3,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              )),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(this.userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Provider.of<AltProfileHelpers>(context, listen: false)
                        .headerAltProfile(context, snapshot, userUid),
                    Provider.of<AltProfileHelpers>(context, listen: false)
                        .divider(context),
                    SizedBox(
                      height: 10,
                    ),
                    Provider.of<AltProfileHelpers>(context, listen: false)
                        .footerProfile(context, this.userUid),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
