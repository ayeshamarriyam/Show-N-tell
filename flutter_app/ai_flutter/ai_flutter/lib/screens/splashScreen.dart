import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class splashScreen extends StatelessWidget {

  static const routeName = '/splash_screen';
  int duration = 0;
  String goTopage = "";

  splashScreen(this.duration, this.goTopage);


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Future.delayed(Duration(seconds: duration,), () async{
      Navigator.popAndPushNamed(context, goTopage);
      //Navigator.pushNamed(context, goTopage);
    });
    return Scaffold(
      backgroundColor: Color(0xff040669),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 200,
          height: 200,
          child: Image.asset('assets/images/logo.png',
          fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
