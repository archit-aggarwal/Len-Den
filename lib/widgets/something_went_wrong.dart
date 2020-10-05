import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FittedBox(
            child: Image.asset('images/SomethingWentWrong.gif'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
