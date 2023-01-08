import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter/painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';


class canvasScreen extends StatefulWidget {
  static const routeName = '/canvasScreen';

  @override
  State<canvasScreen> createState() => _canvasScreenState();
}

class _canvasScreenState extends State<canvasScreen> {
  bool _finished = false;
  PainterController _controller = _newController();

  @override
  void initState() {
    super.initState();
  }

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
            icon: Icon(
              Icons.undo,
            ),
            tooltip: 'Undo',
            onPressed: () {
              if (_controller.isEmpty) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                    Text('Nothing to undo'));
              } else {
                _controller.undo();
              }
            }),
        IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: _controller.clear),
         IconButton(
            icon: new Icon(Icons.check),
            onPressed: () => _show(_controller.finish(), context)),
      ];
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Draw a Sketch'),
          actions: actions,
          bottom: PreferredSize(
            child: DrawBar(_controller),
            preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
          )),
      body: Center(
          child: AspectRatio(
              aspectRatio: 9.0/13.5, child: Painter(_controller))),
    );
  }


  void _show(PictureDetails picture, BuildContext context) {
    String sentence = "";
    File? imagefile = File("sketch.png");
    /*upload(imagefile).then((result) => {
      sentence = result
    });*/
    setState(() {
      _finished = true;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('View your image'),
        ),
        body: Container(
            alignment: Alignment.center,
            child:
                  FutureBuilder<Uint8List>(
                  future: picture.toPNG(),
                  builder:
                      (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          //File? image = File("sketch.png");
                          //_saveToGallery(picture.toPNG());
                          /*
                          upload(imagefile!).then((String result) => {
                            sentence = result
                          });*/
                          return Stack(
                            fit: StackFit.loose,
                              children: [
                                Image.memory(snapshot.data!),
                                FutureBuilder<File>(
                                  future: _saveToGallery(picture.toPNG()),
                                  builder:(BuildContext context, AsyncSnapshot<File> snapshot2) {
                                    switch (snapshot2.connectionState) {
                                      case ConnectionState.done:
                                        if (snapshot2.hasError) {
                                          return Text('Error: ${snapshot2.error}');
                                        } else {


                                          return FutureBuilder<String>(
                                            future: upload(snapshot2.data!),
                                            builder: (BuildContext context, AsyncSnapshot<String> snapshot3) {
                                            switch (snapshot3.connectionState) {
                                              case ConnectionState.done:
                                                if (snapshot3.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot3
                                                          .error}');
                                                } else {
                                                  return Text(snapshot3.data!)
                                                  ;
                                                }
                                              default:
                                                return Container(
                                                    child: FractionallySizedBox(
                                                      widthFactor: 0.1,
                                                      child: AspectRatio(
                                                          aspectRatio: 1.0,
                                                          child: CircularProgressIndicator()),
                                                      alignment: Alignment
                                                          .center,
                                                    ));
                                            }
                                           }
                                          );


                                        }
                                      default:
                                        return Container(
                                            child: FractionallySizedBox(
                                              widthFactor: 0.1,
                                              child: AspectRatio(
                                                  aspectRatio: 1.0,
                                                  child: CircularProgressIndicator()),
                                              alignment: Alignment.center,
                                            ));
                                    }
                                  },)
                        ]);


                        }
                      default:
                        return Container(
                            child: FractionallySizedBox(
                              widthFactor: 0.1,
                              child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: CircularProgressIndicator()),
                              alignment: Alignment.center,
                            ));
                      }
                    },
                  ),


      ),
      );
    }));
  }

  Future<File> _saveToGallery(Future<Uint8List> pictureBytes) async {
    Uint8List pic = await pictureBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/sketch.png';
    print("local file full path ${fullPath}");
    File file = File(fullPath);
    await file.writeAsBytes(pic);
    print(file.path);


    final result = await ImageGallerySaver.saveImage(pic);
    print(result);

    return file;
  }
}
/*
Future<String> uploadBytes(Future<Uint8List> pictureBytes) async {
  //const url = 'http://172.16.49.85:5000/upload';
  const url = 'http://10.0.2.2:5000/upload'; //emulator

  //var bodyEncoded = json.encode(body);
  final request = http.MultipartRequest('POST',Uri.parse(url));
  final headers = { "Content-Type":"multipart/form-data" };

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
  String sentence = (jsonDecode(res.body))['message'];

  print("hi");
  return sentence;
}
*/
Future<String> upload(File image) async {
  //const url = 'http://172.16.49.85:5000/upload';
  const url = 'http://10.0.2.2:5000/upload'; //emulator

  //var bodyEncoded = json.encode(body);
  final request = http.MultipartRequest('POST',Uri.parse(url));
  final headers = { "Content-Type":"multipart/form-data" };
  File imageFile = File(image.path);
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
  String sentence = (jsonDecode(res.body))['message'];

  print("hi");
  return sentence;
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Flexible(child: new StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return new Container(
                  child: new Slider(
                    value: _controller.thickness,
                    onChanged: (double value) => setState(() {
                      _controller.thickness = value;
                    }),
                    min: 1.0,
                    max: 20.0,
                    activeColor: Colors.white,
                  ));
            })),
        new StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return new RotatedBox(
                  quarterTurns: _controller.eraseMode ? 2 : 0,
                  child: IconButton(
                      icon: new Icon(Icons.create),
                      tooltip: (_controller.eraseMode ? 'Disable' : 'Enable') +
                          ' eraser',
                      onPressed: () {
                        setState(() {
                          _controller.eraseMode = !_controller.eraseMode;
                        });
                      }));
            }),
        new ColorPickerButton(_controller, false),
        new ColorPickerButton(_controller, true),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(_iconData, color: _color),
        tooltip: widget._background
            ? 'Change background color'
            : 'Change draw color',
        onPressed: _pickColor);
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Pick color'),
              ),
              body: Container(
                  alignment: Alignment.center,
                  child: ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (Color c) => pickerColor = c,
                  )));
        }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._background
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}