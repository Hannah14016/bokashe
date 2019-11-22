import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  final bool _connected2internet;
  final Function _getImage;

CameraButton(this._connected2internet, this._getImage);

  @override
  Widget build(BuildContext context) {
    return Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 7),
            child: FloatingActionButton(
              onPressed: _connected2internet ? _getImage : null,
              child: Icon(Icons.add_a_photo),
              isExtended: true,
            ),
          );
  }
}