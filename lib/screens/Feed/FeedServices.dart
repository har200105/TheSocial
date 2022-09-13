import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Feed/FeedUtils.dart';
import 'package:thesocial/screens/Feed/FeedHelpers.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';
import 'package:thesocial/services/UploadPost.dart';

class FeedServices extends ChangeNotifier {
  bool loading = false;
  ConstantColors constantColors = ConstantColors();
  Future showPostImage(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: constantColors.blueGreyColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 140),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      height: 250.0,
                      width: 350.0,
                      child: Image.file(
                        Provider.of<FeedUtils>(context, listen: true)
                            .getPostImage,
                        fit: BoxFit.contain,
                      )),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        MaterialButton(
                          child: Text(
                            'Reselect',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Provider.of<FeedHelpers>(context, listen: false)
                                .selectPostImageType(context);
                          },
                        ),
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: loading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  'Confirm Image',
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          onPressed: () {
                            loading = true;
                            notifyListeners();
                            Provider.of<UploadPost>(context, listen: false)
                                .uploadPostImageToFirebase(context)
                                .whenComplete(() {
                              editPostSheet(context);
                              loading = false;
                              notifyListeners();
                              print('image uploaded');
                            });
                            // Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  Future editPostSheet(BuildContext context) {
    TextEditingController _captionController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String captionValidator(value) {
      if (value.isEmpty) {
        return 'please fill the caption';
      } else if (value.toString().length < 3) {
        return 'make sure your caption is long enough';
      }
      return null;
    }

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
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
                Container(
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.image_aspect_ratio,
                              color: constantColors.greenColor,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fit_screen,
                              color: constantColors.yellowColor,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        width: 300,
                        child: Image.file(
                            Provider.of<FeedUtils>(context, listen: false)
                                .getPostImage),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        width: 5,
                        height: 110,
                        color: constantColors.blueColor,
                      ),
                      Container(
                        height: 120,
                        width: 330,
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            validator: captionValidator,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            controller: _captionController,
                            decoration: InputDecoration(
                              hintText: 'Add Caption',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Share',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      if (!formKey.currentState.validate()) {
                        return;
                      }
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .addPostData(_captionController.text, {
                        'caption': _captionController.text,
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getUserName,
                        'useremail': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getUserEmail,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'userimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getUserImage,
                        'postimage':
                            Provider.of<FeedUtils>(context, listen: false)
                                .getPostImageUrl,
                      }).whenComplete(() {
                        print('post data added');
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    })
              ],
            ),
          );
        });
  }
}
