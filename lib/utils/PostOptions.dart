import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class PostOptions extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  showPostOptions(BuildContext context, String caption) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'You Want to Delete This Post?',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  MaterialButton(
                      child: Text('No',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  MaterialButton(
                      color: constantColors.redColor,
                      child: Text('Yes',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .deletePost(caption)
                            .whenComplete(() {
                          print('Post Deleted');
                          Navigator.pop(context);
                        });
                      }),
                ],
              )
            ],
          );
        });
  }
}
