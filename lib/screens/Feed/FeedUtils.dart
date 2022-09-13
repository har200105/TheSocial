import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class FeedUtils extends ChangeNotifier {
  final picker = ImagePicker();
  File postImage;
  File get getPostImage => postImage;
  String postImageUrl;
  String get getPostImageUrl => postImageUrl;

  Future pickPostImage(BuildContext context, ImageSource source) async {
    PickedFile pickedPostImage = await picker.getImage(source: source);

    pickedPostImage == null
        // ignore: unnecessary_statements
        ? 'error occured'
        : postImage = File(pickedPostImage.path);

    print('this is newly selected user post' + pickedPostImage.path);

    notifyListeners();
  }
}
