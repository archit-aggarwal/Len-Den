import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ContactUs(
        logo: AssetImage('images/MyPic.jpeg'),
        email: 'archit.aggarwal023@gmail.com',
        companyName: 'Archit Aggarwal',
        phoneNumber: '+9119319117889',
        githubUserName: 'archit-aggarwal',
        linkedinURL: 'https://www.linkedin.com/in/archit-aggarwal-6a7716189/',
        tagLine: 'Flutter Developer',
        twitterHandle: 'archit_023',
        instagram: 'architaggarwal023',
        cardColor: Colors.white12,
        textColor: Colors.white,
        companyColor: Colors.white,
        taglineColor: Colors.white,
      ),
    );
  }
}
