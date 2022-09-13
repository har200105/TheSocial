import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/LandingPage/LandingUtils.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class HomePageHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bottomNavBar(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      backgroundColor: Colors.grey[900],
      currentIndex: index,
      bubbleCurve: Curves.bounceOut,
      scaleCurve: Curves.ease,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.2,
      iconSize: 32.0,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(Icons.message_rounded)),
        CustomNavigationBarItem(
            icon: CircleAvatar(
          backgroundImage: Provider.of<FirebaseOperations>(
                    context,
                    listen: false,
                  ).getUserImage !=
                  null
              ? NetworkImage(Provider.of<FirebaseOperations>(
                    context,
                    listen: false,
                  ).getUserImage ??
                  "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100")
              : null,
        )),
      ],
    );
  }
}
