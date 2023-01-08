import 'package:ai_flutter/routes.dart';
import 'package:ai_flutter/screens/homeScreen.dart';
import 'package:ai_flutter/screens/signInScreen.dart';
import 'package:ai_flutter/screens/signUpScreen.dart';
import 'package:ai_flutter/screens/splashScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShowN'tell",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      home: splashScreen(3, homeScreen.routeName),

    );
  }
}





// backgroundColor: Color(0xff040669),
