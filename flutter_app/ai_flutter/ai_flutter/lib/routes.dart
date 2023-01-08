

import 'package:ai_flutter/screens/captureScreen.dart';
import 'package:ai_flutter/screens/homeScreen.dart';
import 'package:ai_flutter/screens/signInScreen.dart';
import 'package:ai_flutter/screens/signUpScreen.dart';
import 'package:ai_flutter/screens/canvasScreen.dart';
import 'package:ai_flutter/screens/galleryScreen.dart';
//import 'package:ai_flutter/screens/LoginPageWidget.dart';





import 'package:flutter/cupertino.dart';

final Map <String,WidgetBuilder> routes =  {

  homeScreen.routeName: (context) => homeScreen(),
  signInScreen.routeName: (context) => signInScreen(),
  signUpScreen.routeName: (context) => signUpScreen(),
  captureScreen.routeName: (context) => captureScreen(),
  canvasScreen.routeName: (context) => canvasScreen(),
  galleryScreen.routeName: (context) => galleryScreen(),
  //LoginPageWidget.routeName: (context) => LoginPageWidget(),

};
