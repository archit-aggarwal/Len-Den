import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedAppBar extends StatelessWidget {
  RoundedAppBar({this.firstTitle, this.secondTitle, this.pic});
  final String firstTitle, secondTitle, pic;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Text(
              firstTitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 36.0,
                color: Color(0xff03DAC6),
                fontWeight: FontWeight.w900,
                letterSpacing: .5,
              ),
            ),
            Text(
              secondTitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 36.0,
                color: Color(0xff03DAC6),
                fontWeight: FontWeight.w900,
                letterSpacing: .5,
              ),
            ),
          ],
        ),
      ),
      height: 200.0,
      width: double.infinity,
      decoration: new BoxDecoration(
        // color: Colors.orange,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6), BlendMode.dstATop),
          image: AssetImage(pic),
          fit: BoxFit.cover,
        ),
        boxShadow: [new BoxShadow(blurRadius: 40.0)],
        borderRadius: new BorderRadius.vertical(
            bottom: new Radius.elliptical(
                MediaQuery.of(context).size.width, 100.0)),
      ),
    );
  }
}
