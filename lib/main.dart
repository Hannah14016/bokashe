import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  bool _masked = false;

  void _saveImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final bytes = _image.readAsBytesSync();
    File file = File('${dir}/photo1.jpg');
    file.writeAsBytes(bytes);
    print('保存しますた');
  }

  void _sendImage() {
    final bytes = _image.readAsBytesSync();
    String imageBase64 = base64Encode(bytes);
    print(imageBase64);
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      _masked = true;
      _sendImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bokashe',
      home: Scaffold(
        appBar: AppBar(
          title: Text('bokashe'),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _image != null
                ? Expanded(
                    flex: 3,
                    child: Image.file(
                      _image,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : Expanded(
                    flex: 3,
                    child: Center(
                      child: Text('写真をとろう'),
                    ),
                  ),
            _masked == true
                ? Expanded(
                    flex: 2,
                    child: Center(
                      child: RaisedButton(
                        onPressed: _saveImage,
                        child: Icon(Icons.save_alt),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Center(
                      child: RaisedButton(
                        onPressed: _getImage,
                        child: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
