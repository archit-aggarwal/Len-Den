import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:len_den/widgets/change_username.dart';

class UserProfile extends StatefulWidget {
  static const String id = 'User Profile Screen';
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User currentUser = FirebaseAuth.instance.currentUser;
  String userName;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userName = (currentUser.displayName != null)
        ? currentUser.displayName
        : "No User Name";
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {});
    });
  }

  getPhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await currentUser.updateProfile(
        photoURL: File(pickedFile.path).path,
      );
      await currentUser.reload();
      setState(() {
        currentUser = FirebaseAuth.instance.currentUser;
      });
    }
  }

  getUserName(newUserName) async {
    await currentUser.updateProfile(
      displayName: newUserName,
    );
    await currentUser.reload();
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: GetClipper(),
        ),
        Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    image: DecorationImage(
                      image: (currentUser.photoURL != null)
                          ? FileImage(File(currentUser.photoURL))
                          : AssetImage('images/AnonymousUser.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 30.0,
                  width: 250.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.yellow,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        getPhoto();
                      },
                      child: Center(
                        child: Text(
                          'Upload/Edit Profile Image',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //         <--- border radius here
                        ),
                    color: Colors.white12,
                  ),
                  child: Text(
                    userName,
                    style: GoogleFonts.montserrat(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  height: 30.0,
                  width: 250.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.lightGreenAccent,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: EditUserName(
                                callBack: (newUserName) {
                                  getUserName(newUserName);
                                  setState(() {
                                    userName = newUserName;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Edit User Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //         <--- border radius here
                        ),
                    color: Colors.white12,
                  ),
                  child: Text(
                    currentUser.email,
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                ),
              ],
            ))
      ],
    ));
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
