import 'dart:io';

import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final File _image;
  final File _maskedImage;
  final bool _masked;

  final Function _initMainState;

  HomeButton(this._image, this._maskedImage, this._masked, this._initMainState);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 7),
      child: ButtonTheme(
        minWidth: 190,
        height: 50,
        child: RaisedButton(
          onPressed: _initMainState,
          child: Icon(Icons.home),
        ),
      ),
    );
  }
}
