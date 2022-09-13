import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Feed/Feed.dart';
import 'package:thesocial/screens/ChatList/ChatList.dart';
import 'package:thesocial/screens/Profile/Profile.dart';
import 'package:thesocial/screens/HomePage/HomePageHelpers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homepageController,
        children: [Feed(), ChatList(), Profile()],
        //physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomePageHelpers>(context, listen: false)
          .bottomNavBar(context, pageIndex, homepageController),
    );
  }
}
