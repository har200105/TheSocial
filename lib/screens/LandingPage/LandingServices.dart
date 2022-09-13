import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/HomePage/HomePage.dart';
import 'package:thesocial/screens/LandingPage/LandingUtils.dart';
import 'package:thesocial/services/FirebaseOperations.dart';
import '../../constants/Constantcolors.dart';
import '../../services/Authentication.dart';

class LandingServices extends ChangeNotifier {
  bool loading = false;
  ConstantColors constantColors = ConstantColors();

  dynamic showUserAvatar(BuildContext context) {
    if (Provider.of<LandingUtils>(context, listen: false).getUserAvatar !=
        null) {
      return showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.4,
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
                    CircleAvatar(
                      radius: 70.0,
                      backgroundColor: constantColors.transperant,
                      backgroundImage: Provider.of<LandingUtils>(context,
                                      listen: true)
                                  .userAvatar !=
                              null
                          ? FileImage(
                              Provider.of<LandingUtils>(context, listen: true)
                                  .userAvatar)
                          : null,
                    ),
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
                              Provider.of<LandingUtils>(context, listen: false)
                                  .userAvatar = null;
                              Provider.of<LandingUtils>(context, listen: false)
                                  .pickUserAvatar(context, ImageSource.gallery);
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
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .uploadUserAvatar(context)
                                  .whenComplete(() {
                                print('popping the context');
                                loading = false;
                                notifyListeners();
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ));
          });
    }
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
                children: snapshot.data.docs
                    .map<Widget>((DocumentSnapshot documentSnapshot) {
              return ListTile(
                trailing: Container(
                  height: 50,
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.blueColor,
                        ),
                        onPressed: () async {
                          await Provider.of<Authentication>(context,
                                  listen: false)
                              .logIntoAccount(documentSnapshot.get('useremail'),
                                  documentSnapshot.get('userpassword'));
                          await Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .fetchUserProfileInfo(context);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: HomePage(),
                                type: PageTransitionType.leftToRight,
                              ));
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.trashAlt,
                          color: constantColors.redColor,
                        ),
                        onPressed: () {
                          Provider.of<FirebaseOperations>(
                            context,
                            listen: false,
                          )
                              .deleteAccount(documentSnapshot.get('userid'))
                              .whenComplete(() {
                            print('account deleted');
                          });
                        },
                      ),
                    ],
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: constantColors.darkColor,
                  backgroundImage: NetworkImage(documentSnapshot
                          .get('userimage') ??
                      "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100"),
                ),
                title: Text(
                  documentSnapshot.get('username'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constantColors.greenColor,
                    fontSize: 15.0,
                  ),
                ),
                subtitle: Text(
                  documentSnapshot.get('useremail'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constantColors.whiteColor,
                    fontSize: 14.0,
                  ),
                ),
              );
            }).toList());
          }
        },
      ),
    );
  }

  Future signInSheet(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
    GlobalKey<FormState> _usernameKey = GlobalKey<FormState>();
    GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
    String _emailValidator(value) {
      if (value.isEmpty) return 'please fill the email';
      return null;
    }

    String _usernameValidator(value) {
      if (value.isEmpty) return 'please fill the username';
      return null;
    }

    String _passwordValidator(value) {
      if (value.isEmpty)
        return 'please fill the email';
      else if (value.toString().length < 6)
        return 'make sure password has minimum 6 characters';
      return null;
    }

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 140),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              CircleAvatar(
                backgroundColor: constantColors.redColor,
                radius: 70.0,
                backgroundImage:
                    Provider.of<LandingUtils>(context, listen: true)
                                .userAvatar !=
                            null
                        ? FileImage(
                            Provider.of<LandingUtils>(context, listen: true)
                                .userAvatar)
                        : null,
                child: Provider.of<LandingUtils>(context, listen: true)
                            .userAvatar !=
                        null
                    ? null
                    : Icon(
                        FontAwesomeIcons.userCircle,
                        size: 80,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _emailKey,
                  child: TextFormField(
                    validator: _emailValidator,
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Email ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _usernameKey,
                  child: TextFormField(
                    validator: _usernameValidator,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Username ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _passwordKey,
                  child: TextFormField(
                    obscureText: true,
                    validator: _passwordValidator,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter Password ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                  backgroundColor: constantColors.redColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                    if (_emailKey.currentState.validate() &&
                        _usernameKey.currentState.validate() &&
                        _passwordKey.currentState.validate()) {
                      try {
                        var result = await Provider.of<Authentication>(context,
                                listen: false)
                            .registerAccount(_emailController.text.trim(),
                                _passwordController.text.trim());
                        if (!result) {
                          showWarning(
                              context,
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .errorMsg);
                          return;
                        } else {
                          await Provider.of<FirebaseOperations>(
                            context,
                            listen: false,
                          ).addUserToCollection(context, {
                            'useruid': Provider.of<Authentication>(
                              context,
                              listen: false,
                            ).getUserUid,
                            'useremail': _emailController.text,
                            'username': _usernameController.text,
                            'userpassword': _passwordController.text,
                            'userimage': Provider.of<LandingUtils>(
                              context,
                              listen: false,
                            ).getUserAvatarUrl
                          });
                          await Provider.of<Authentication>(context,
                                  listen: false)
                              .logIntoAccount(_emailController.text,
                                  _passwordController.text);
                          await Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .fetchUserProfileInfo(context);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: HomePage(),
                                type: PageTransitionType.leftToRight,
                              ));
                        }
                      } catch (e) {
                        print('hello from sign up error');
                        print(e);
                      }
                    }
                  })
            ]),
          );
        });
  }

  Future loginSheet(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
    GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
    String _emailValidator(value) {
      if (value.isEmpty) {
        return 'please fill the email';
      }
      return null;
    }

    String _passwordValidator(value) {
      if (value.isEmpty) {
        return 'please fill the password';
      } else if (value.toString().length < 6) {
        return 'make sure password contains at least 6 char';
      }
      return null;
    }

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.78,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 140),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _emailKey,
                  child: TextFormField(
                    controller: _emailController,
                    validator: _emailValidator,
                    decoration: InputDecoration(
                      hintText: 'Enter Email ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _passwordKey,
                  child: TextFormField(
                    validator: _passwordValidator,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter Password ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                  backgroundColor: constantColors.blueColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                    if (_emailKey.currentState.validate() &&
                        _passwordKey.currentState.validate()) {
                      Provider.of<Authentication>(context, listen: false)
                          .logIntoAccount(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      )
                          .then((result) async {
                        await Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .fetchUserProfileInfo(context);
                        print(result);
                        if (!result) {
                          showWarning(
                              context,
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .errorMsg);
                          return;
                        }
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: HomePage(),
                              type: PageTransitionType.leftToRight,
                            ));
                      }).catchError((e) {
                        showWarning(
                            context,
                            Provider.of<Authentication>(context, listen: false)
                                .errorMsg);
                      });
                    }
                  })
            ]),
          );
        });
  }

  Future showWarning(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
                child: Text(
              warning,
              style: TextStyle(
                color: constantColors.yellowColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            )),
          );
        });
  }

  Future avatarSelectOptions(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false)
                            .pickUserAvatar(context, ImageSource.camera)
                            .whenComplete(() {
                          if (Provider.of<LandingUtils>(context, listen: false)
                                  .getUserAvatar ==
                              null) {
                            return;
                          }
                          Provider.of<LandingServices>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false)
                            .pickUserAvatar(context, ImageSource.gallery)
                            .whenComplete(() {
                          if (Provider.of<LandingUtils>(context, listen: false)
                                  .getUserAvatar ==
                              null) {
                            return;
                          }
                          showUserAvatar(context);
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
