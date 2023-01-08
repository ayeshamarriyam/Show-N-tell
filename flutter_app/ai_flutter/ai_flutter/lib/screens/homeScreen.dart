import 'package:ai_flutter/screens/captureScreen.dart';
import 'package:ai_flutter/screens/canvasScreen.dart';
import 'package:ai_flutter/screens/galleryScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class homeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _selectedIndex = 0;
  var routeNames = {galleryScreen.routeName, captureScreen.routeName};
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<dynamic> post() async {
    //const url = 'http://192.168.42.177:5000/success';
    const url = 'http://10.0.2.2:5000/success'; //emulator
    var body;
    var bodyEncoded = json.encode(body);
    var response = await http.post(Uri.parse(url),   body: bodyEncoded, headers: {
      "Content-Type":"application/json"
    },);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('A network error occurred');
    }
    print("hi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Color(0xff040669),
      ),
      body: Container(
        child: Center(
          child: InkWell (
            onTap: () {
              Navigator.pushNamed(context, canvasScreen.routeName);
            },
            child: Text("Click here to draw!",
              style: TextStyle(
              fontSize: 40,
              color: Colors.cyan,
              ),
            ),
          ),
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.browse_gallery),
                label: 'Gallery',
                backgroundColor: Color(0xff040669)
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: 'Camera',
                backgroundColor: Color(0xff040669),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox),
              label: 'Test',
              backgroundColor: Color(0xDCDB0D20),
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: (_selectedIndex){
            _onItemTapped(_selectedIndex);
            if(_selectedIndex < 2) {
              Navigator.pushNamed(
                  context, routeNames.elementAt(_selectedIndex));
            } else {
              //   const url = 'http://127.0.0.1:5000/success/fahad';
              //   var body;
              //   var bodyEncoded = json.encode(body);
              //   var response = await http.post(Uri.parse(url), body: bodyEncoded, headers: {
              //     "Content-Type":"application/json"
              //   },)
              post();
            }
          },
          elevation: 5
      ),


    );
  }
}



