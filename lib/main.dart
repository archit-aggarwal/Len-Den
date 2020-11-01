import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:len_den/screens/homepage_screen.dart';
import 'package:len_den/screens/individual_payments_screen.dart';
import 'package:len_den/screens/individual_transaction_screen.dart';
import 'package:len_den/screens/login_screen.dart';
import 'package:len_den/widgets/loading.dart';
import 'package:len_den/widgets/user_profile.dart';
import 'package:len_den/widgets/something_went_wrong.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return SomethingWentWrong();
    }

    if (!_initialized) {
      return Loading();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: (FirebaseAuth.instance.currentUser != null)
          ? HomePage.id
          : LoginScreen.id,
      theme: ThemeData.dark(),
      routes: {
        HomePage.id: (context) => HomePage(),
        LoginScreen.id: (context) => LoginScreen(),
        IndividualTransaction.id: (context) => IndividualTransaction(),
        IndividualScreen.id: (context) => IndividualScreen(),
        UserProfile.id: (context) => UserProfile(),
      },
    );
  }
}

//TODO: Add Welcome Screen (How to Use App at first time login)
//TODO: Add Payment Reminder + Link generation
//TODO: Add PDF Generation for Report
//TODO: Add Authentication using Google Account & SMS (Phone)
//TODO: Add Social Authentication using Facebook , Github & Twitter
//TODO: Add Use of Google People API for Google Contacts
//TODO: Add Support for Web & iOS
//TODO: Add Animations for Loading & Navigation
//TODO: Deploy on Play Store & Github
