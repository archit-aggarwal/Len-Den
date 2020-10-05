import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:len_den/screens/homepage_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "Login Screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  Future<String> _authSignin(LoginData data) async {
    try {
      user = (await auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      ))
          .user;
      if (user != null) return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Signing Failed';
  }

  Future<String> _authRegister(LoginData data) async {
    try {
      user = (await auth.createUserWithEmailAndPassword(
        email: data.name,
        password: data.password,
      ))
          .user;
      if (user != null) return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    }
    return 'Registration Failed';
  }

  Future<String> _recoverPassword(String name) {
    // print('Name: $name');
    // return Future.delayed(loginTime).then((_) {
    //   if (!users.containsKey(name)) {
    //     return 'Username not exists';
    //   }
    //   return null;
    // });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: FlutterLogin(
            title: 'Len Den',
            logo: 'images/logo.png',
            onLogin: _authSignin,
            onSignup: _authRegister,
            onSubmitAnimationCompleted: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    user: user,
                  ),
                ),
              );
            },
            onRecoverPassword: _recoverPassword,
          ),
        ),
      ),
    );
  }
}
