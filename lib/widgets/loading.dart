import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Container(
          child: Center(
            child: SpinKitChasingDots(
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}
