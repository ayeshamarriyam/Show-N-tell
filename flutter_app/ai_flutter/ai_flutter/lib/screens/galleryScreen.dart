import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class galleryScreen extends StatefulWidget {
  static const routeName = '/galleryScreen';

  @override
  State<galleryScreen> createState() => _galleryScreenState();
}
class _galleryScreenState extends State<galleryScreen> {
  ImagePicker picker = ImagePicker();
  XFile? image;
  String sentence = "";
  bool newsentence = false;
  void upload() async {
    //const url = 'http://172.16.49.85:5000/upload';
    const url = 'http://10.0.2.2:5000/upload'; //emulator

    //var bodyEncoded = json.encode(body);
    final request = http.MultipartRequest('POST',Uri.parse(url));
    final headers = { "Content-Type":"multipart/form-data" };
    File imageFile = File(image!.path);
    request.files.add(http.MultipartFile('image',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split('/').last));
    request.headers.addAll(headers);

    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print(jsonDecode(res.body));
    } else {
      print('A network error occurred');
    }
    sentence = (jsonDecode(res.body))['message'];
    newsentence = true;
    print("hi");
    print(sentence);
    setState(() {
      //update UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
            title: Text("Image Picker from Gallery"),
            backgroundColor: Colors.redAccent
        ),
        body: Container(
            padding: EdgeInsets.only(top:20, left:20, right:20),
            alignment: Alignment.topCenter,
            child: Column(
              children: [

                ElevatedButton(
                    onPressed: () async {
                      image = await picker.pickImage(source: ImageSource.gallery);
                      newsentence = false;
                      setState(() {
                        //update UI
                      });
                    },
                    child: Text("Pick Image")
                ),

                image == null?Container():
                Flexible(
                    fit: FlexFit.tight,
                    child: Image.file(File(image!.path))
                ),
                image == null?Container():
                ElevatedButton(
                    onPressed: () async {
                      upload();
                    },
                    child: Text("Upload Image")
                ),
                newsentence == false?Container():
                    InkWell(
                      child: Text(
                        sentence
                      )
                  )
              ],)
        )
    );
  }
}