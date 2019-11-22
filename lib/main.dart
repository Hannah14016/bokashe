import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:bokashe/widgets/image_screen.dart';

import './widgets/home_screen.dart';
import './widgets/home_button.dart';
import './widgets/camera_button.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  File _maskedImage;
  bool _masked = false;
  final String _baseUrl = 'https://secure-shore-17992.herokuapp.com/';
  String _imageBase64;
  String _fileName;
  Directory _dir;
  StreamSubscription<ConnectivityResult> _subscription;
  bool _connected2internet = false;

  @override
  initState() {
    super.initState();

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _connected2internet = result != ConnectivityResult.none;
      });
    });
  }

  @override
  dispose() {
    super.dispose();

    _subscription.cancel();
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _dir = await getApplicationDocumentsDirectory();

    setState(() {
      _image = image;
      final bytes = _image.readAsBytesSync();
      _imageBase64 = base64Encode(bytes);
      _fileName = _image.path.split('/').last;
      _masked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _image != null
        ? ImageScreen(_baseUrl, _imageBase64, _fileName, _dir)
        : HomeScreen(_connected2internet);
    Widget buttonWidget = _masked == true
        ? HomeButton(_image, _maskedImage, _masked, () {
            setState(() {
              _image = null;
              _maskedImage = null;
              _masked = false;
            });
          })
        : CameraButton(_connected2internet, _getImage);
    return MaterialApp(
      title: 'bokashe',
      theme: ThemeData.from(
        colorScheme: ColorScheme.dark(
          surface: Color.fromRGBO(46, 49, 146, 1),
          primary: Colors.deepPurpleAccent,
          secondary: Colors.deepPurpleAccent,
          background: Color.fromRGBO(50, 50, 70, 1),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
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
