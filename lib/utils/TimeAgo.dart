import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeAgo extends ChangeNotifier {
  String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;

  showTimeGo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    //notifyListeners();
  }
}
