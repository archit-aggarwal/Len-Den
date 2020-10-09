import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePassword extends StatefulWidget {
  static const String id = 'Add Transaction Screen';
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  String message = "";
  int amount;
  var _oldPasswordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkCurrentPasswordValid = true;
  bool loading = false;
  var user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? Material(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    height: 400.0,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // Add TextFormFields and RaisedButton here.
                          Container(
                            child: TextFormField(
                              // initialValue: message,
                              decoration: InputDecoration(
                                labelText: "Current Password",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(),
                                ),
                                errorText: checkCurrentPasswordValid
                                    ? null
                                    : "Please double check your current password",
                                prefixIcon: Icon(FontAwesomeIcons.commentDots,
                                    color: Colors.white),
                              ),
                              controller: _oldPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "New Password",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(),
                                ),
                              ),
                              controller: _newPasswordController,
                              obscureText: true,
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Repeat Password",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(),
                                ),
                              ),
                              controller: _repeatPasswordController,
                              validator: (value) {
                                if (_oldPasswordController.text ==
                                    _newPasswordController.text)
                                  return 'Password Entered is same as '
                                      'Current Password. Try something new';
                                if (!validatePassword(value))
                                  return 'Please Enter Strong Password';
                                return _newPasswordController.text == value
                                    ? null
                                    : "Please validate your entered password";
                              },
                              obscureText: true,
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              EmailAuthCredential credential =
                                  EmailAuthProvider.credential(
                                      email: user.email,
                                      password: _oldPasswordController.text);
                              try {
                                await user
                                    .reauthenticateWithCredential(credential);
                                checkCurrentPasswordValid = true;
                              } catch (error) {
                                checkCurrentPasswordValid = false;
                              }
                              setState(() {});
                              if (_formKey.currentState.validate() &&
                                  checkCurrentPasswordValid) {
                                setState(() {
                                  loading = true;
                                });
                                await user.updatePassword(
                                    _newPasswordController.text);
                                setState(() {
                                  loading = false;
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Text('Update Password'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SpinKitFadingCube(
            color: Colors.white,
            size: 50.0,
          );
  }
}
