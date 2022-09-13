import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Feed/FeedHelpers.dart';

class Feed extends StatelessWidget {
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
                Icons.camera_enhance_rounded,
                size: 30,
                color: constantColors.greenColor,
              ),
              onPressed: () {
                Provider.of<FeedHelpers>(context, listen: false)
                    .selectPostImageType(context);
              },
            )
          ],
          title: RichText(
              text: TextSpan(
                  text: 'Social',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: constantColors.whiteColor,
                  ),
                  children: [
                TextSpan(
                    text: 'Feed',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0))
              ])),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Provider.of<FeedHelpers>(context).feedBody(context),
        ));
  }
}
