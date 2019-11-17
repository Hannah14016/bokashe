import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  bool _masked = false;
  final String _baseUrl = 'https://secure-shore-17992.herokuapp.com/';
  String imageBase64;
  String fileName;
  Directory _dir;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _dir = await getApplicationDocumentsDirectory();

    setState(() {
      _image = image;
      final bytes = _image.readAsBytesSync();
      imageBase64 = base64Encode(bytes);
      fileName = _image.path.split('/').last;
      _masked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _image != null
        ? FutureBuilder<http.Response>(
            future: http.post(
              _baseUrl,
              body: {
                "image": imageBase64,
                "name": fileName,
              },
            ),
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  print('==========data=======');
                  print(snapshot.data);
                  final decodedResponse = json.decode(snapshot.data.body);

                  final bytes = base64Decode(decodedResponse['image']);
                  File file = File(
                      '${_dir.path}/${decodedResponse['name'].split('.')[0]}_masked.jpg');
                  file.writeAsBytesSync(bytes);
                  print(file.path);
                  return Center(
                    child: Image.file(
                      file,
                      fit: BoxFit.fitWidth,
                    ),
                  );
                default:
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  );
              }
            },
          )
        : Center(
            child: Center(
              child: Text(
                'Let\'s take a picture!!!!',
                style: TextStyle(fontSize: 50),
                textAlign: TextAlign.center,
              ),
            ),
          );
    Widget buttonWidget = _masked == true
        ? Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 7),
            child: ButtonTheme(
              minWidth: 190,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    _image = null;
                    _masked = false;
                  });
                },
                child: Icon(Icons.home),
                color: Colors.deepPurpleAccent,
              ),
            ),
          )
        : Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 7),
            child: FloatingActionButton(
              onPressed: _getImage,
              child: Icon(Icons.add_a_photo),
              backgroundColor: Colors.deepPurpleAccent,
              isExtended: true,
            ),
          );
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
        accentColor: Colors.black,
      ),
      title: 'bokashe',
      home: Scaffold(
        backgroundColor: Color.fromRGBO(50, 50, 70, 1),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('bokashe'),
        ),
        body: SafeArea(
          bottom: true,
          child: Stack(
            children: <Widget>[
              imageWidget,
              buttonWidget,
            ],
          ),
        ),
      ),
    );
  }
}
