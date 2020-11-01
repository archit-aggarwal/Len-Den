import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:len_den/screens/qrcode_screen.dart';
import 'package:len_den/widgets/rounded_appbar.dart';
import 'package:len_den/widgets/user_profile.dart';
import 'package:len_den/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:len_den/widgets/about_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HistoryScreen extends StatefulWidget {
  static const String id = 'History Screen';

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future _signOut() async {
    if (isSignedIn == true)
      await googleSignIn.signOut();
    else
      await _auth.signOut();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount googleUser;
  bool isSignedIn = false;

  checkSignedIn() async {
    isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn == true) googleUser = googleSignIn.currentUser;
  }

  @override
  void initState() {
    checkSignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            RoundedAppBar(
              firstTitle: "User History",
              secondTitle: "& Settings",
              pic: 'images/HistoryScreen.webp',
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.envelope),
                  title: Text("User Profile"),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    UserProfile.id,
                  );
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: ListTile(
                  title: Text('Scan QR Code'),
                  leading: Icon(FontAwesomeIcons.qrcode),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRCode()),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: ListTile(
                  title: Text('About Me'),
                  leading: Icon(FontAwesomeIcons.questionCircle),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutMe()),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: ListTile(
                  title: Text('Sign Out'),
                  leading: Icon(FontAwesomeIcons.signOutAlt),
                ),
                onPressed: () async {
                  CoolAlert.show(
                    context: context,
                    onConfirmBtnTap: () async {
                      _signOut().whenComplete(() {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginScreen.id, (Route<dynamic> route) => false);
                      });
                    },
                    type: CoolAlertType.confirm,
                    text: "Do you want to Log Out",
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),

      //TODO: Add Phone Number
      //   title: 'Phone Number',
      //   leading: Icon(FontAwesomeIcons.phone),
    );
  }
}
