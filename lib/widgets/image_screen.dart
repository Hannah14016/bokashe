import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ImageScreen extends StatelessWidget {
  final String _baseUrl;
  final String _imageBase64;
  final String _fileName;
  final Directory _dir;

  ImageScreen(this._baseUrl, this._imageBase64, this._fileName, this._dir);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: http.post(
        _baseUrl,
        body: {
          "image": _imageBase64,
          "name": _fileName,
        },
      ),
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final decodedResponse = json.decode(snapshot.data.body);

            final bytes = base64Decode(decodedResponse['image']);
            File file = File(
                '${_dir.path}/${decodedResponse['name'].split('.')[0]}_masked.jpg');
            file.writeAsBytesSync(bytes);
            return Center(
              child: Image.file(
                file,
                fit: BoxFit.fitWidth,
              ),
            );
          default:
            return Center(
              child: CircularProgressIndicator(
              ),
            );
        }
      },
    );
  }
}
