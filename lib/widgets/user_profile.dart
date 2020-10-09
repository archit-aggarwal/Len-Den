import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:len_den/widgets/update_password.dart';
import 'package:len_den/widgets/update_username.dart';

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
          child: Container(color: Colors.black.withOpacity(0.6)),
          clipper: GetClipper(),
        ),
        Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Stack(
                    fit: StackFit.loose,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 140.0,
                            height: 140.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                image: (currentUser.photoURL != null)
                                    ? FileImage(File(currentUser.photoURL))
                                    : AssetImage('images/AnonymousUser.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 90.0, right: 100.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  getPhoto();
                                },
                                child: new CircleAvatar(
                                  backgroundColor: Color(0xff03DAC6),
                                  radius: 22.0,
                                  child: new Icon(
                                    Icons.brush,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.mail),
                      title: Text(
                        currentUser.email,
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70),
                      ),
                      // trailing: IconButton(
                      //     icon: Icon(Icons.create), onPressed: () {}),
                    ),
                    elevation: 18.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(
                        userName,
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.create),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
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
                          }),
                    ),
                    elevation: 18.0,
                  ),
                ),
                RaisedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: UpdatePassword(),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.vpn_key),
                  label: Text('Update Password'),
                  color: Color(0xff03DAC6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
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
