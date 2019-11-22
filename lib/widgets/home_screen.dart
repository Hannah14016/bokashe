import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
final bool _connected2internet;

HomeScreen(this._connected2internet);

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Center(
              child: Text(
                _connected2internet
                    ? 'Let\'s take a picture!'
                    : 'Seems like you\'re offline. Please connect to the internet.',
                style: TextStyle(fontSize: 50),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}