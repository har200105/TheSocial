import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/ChatRoom/ChatRoomHelper.dart';
import 'package:thesocial/Message/GroupMessageHelper.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/AltProfile/AltProfileHelpers.dart';
import 'package:thesocial/screens/Chat/ChatHelpers.dart';
import 'package:thesocial/screens/ChatList/ChatListHelpers.dart';
import 'package:thesocial/screens/LandingPage/LandingHelpers.dart';
import 'package:thesocial/screens/LandingPage/LandingServices.dart';
import 'package:thesocial/screens/LandingPage/LandingUtils.dart';
import 'package:thesocial/screens/SpashScreen/SplashScreen.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';
import 'package:thesocial/screens/HomePage/HomePageHelpers.dart';
import 'package:thesocial/screens/Profile/ProfileHelpers.dart';
import 'package:thesocial/screens/Feed/FeedHelpers.dart';
import 'package:thesocial/screens/Feed/FeedUtils.dart';
import 'package:thesocial/screens/Feed/FeedServices.dart';
import 'package:thesocial/services/UploadPost.dart';
import 'package:thesocial/utils/TimeAgo.dart';
import 'package:thesocial/utils/PostOptions.dart';
import 'package:thesocial/widgets/GlobalWidgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatListHelpers()),
        ChangeNotifierProvider(create: (_) => ChatHelpers()),
        ChangeNotifierProvider(create: (_) => GlobalWidgets()),
        ChangeNotifierProvider(create: (_) => AltProfileHelpers()),
        ChangeNotifierProvider(create: (_) => PostOptions()),
        ChangeNotifierProvider(create: (_) => TimeAgo()),
        ChangeNotifierProvider(create: (_) => FeedServices()),
        ChangeNotifierProvider(create: (_) => FeedUtils()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(create: (_) => ProfileHelpers()),
        ChangeNotifierProvider(create: (_) => HomePageHelpers()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingServices()),
        ChangeNotifierProvider(create: (_) => ChatRoomHelper()),
        ChangeNotifierProvider(create: (_) => GroupMessagingHelper()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: constantColors.blueColor,
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
