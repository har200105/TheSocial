import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class LandingUtils extends ChangeNotifier {
  final picker = ImagePicker();
  File userAvatar;
  File get getUserAvatar => userAvatar;
  String userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    PickedFile pickedUserAvatar = await picker.getImage(source: source);
    pickedUserAvatar == null
        ? print('select image')
        : userAvatar = File(pickedUserAvatar.path);
    //print('this is newly selected user avatar' + userAvatar.path);

    // userAvatar != null
    //     ? Provider.of<FirebaseOperations>(context, listen: false)
    //         .uploadUserAvatar(context)
    //     : print('select image-2');

    notifyListeners();
  }
}
