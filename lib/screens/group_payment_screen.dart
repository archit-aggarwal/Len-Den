import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:len_den/model/group.dart';
import 'package:len_den/widgets/rounded_appbar.dart';
import 'package:len_den/widgets/something_went_wrong.dart';
import 'add_group_screen.dart';
import 'group_transaction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as Cloud;
import 'package:firebase_auth/firebase_auth.dart';

class GroupScreen extends StatefulWidget {
  static const String id = 'Group Screen';

  @override
  _GroupScreen createState() => _GroupScreen();
}

class _GroupScreen extends State<GroupScreen> {
  Cloud.CollectionReference groups;
  Future<void> addGroup(Group newGroup) async {
    Map<String, dynamic> group = newGroup.toJson();
    print('Returned from Transaction Book toJson');
    print(group['avatar']);
    return groups
        .add(group)
        .then((value) => CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: "Group Added Successfully",
            ))
        .catchError((error) => CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "Failed to add Group: $error",
            ));
  }

  @override
  void initState() {
    groups = Cloud.FirebaseFirestore.instance
        .collection('${FirebaseAuth.instance.currentUser.uid}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(FontAwesomeIcons.googlePlusG),
        label: Text(
          ' Add Group',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return AddGroupScreen(
                callBack: (Group newGroup) async {
                  await addGroup(newGroup);
                  Navigator.pop(context);
                },
              );
            }),
          );
        },
      ),
      body: StreamBuilder<Cloud.QuerySnapshot>(
        stream: groups.orderBy('time').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<Cloud.QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return SomethingWentWrong();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitFadingCube(
              color: Colors.white,
              size: 50.0,
            );
          }
          return Container(
            child: Column(
              children: <Widget>[
                RoundedAppBar(
                  firstTitle: "Group",
                  secondTitle: "Payments",
                  pic: 'images/GroupPayment.jpg',
                ),
                (snapshot.data.docs.length > 0)
                    ? Container(
                        height: 390.0,
                        margin: EdgeInsets.all(20),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            Cloud.DocumentSnapshot ds =
                                snapshot.data.docs[index];
                            if (ds.id != 'Individual Payments') {
                              Group group = Group.fromJson(ds.data());
                              return Container(
                                width: 200,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      group.groupName,
                                      style: GoogleFonts.lato(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: group.groupMembers.length,
                                        itemBuilder:
                                            (BuildContext context, int idx) {
                                          return ListTile(
                                            leading: Icon(Icons.account_circle),
                                            title: Text(
                                              group.groupMembers[idx]
                                                  .contactName,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    RaisedButton(
                                      padding: EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.blue)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return GroupTransaction(
                                                ds: ds,
                                                group: group,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      color: Colors.blueAccent,
                                      textColor: Colors.white,
                                      child: Text(
                                        "Open Group",
                                        style: GoogleFonts.robotoCondensed(
                                          fontSize: 16.0,
                                          // color: Colors.,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    RaisedButton(
                                      padding: EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)),
                                      onPressed: () {
                                        groups.doc(ds.id).delete();
                                      },
                                      color: Colors.red,
                                      textColor: Colors.white,
                                      child: Text(
                                        "Delete Group",
                                        style: GoogleFonts.robotoCondensed(
                                          fontSize: 16.0,
                                          // color: Colors.,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else
                              return null;
                          },
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 30.0,
                          horizontal: 10.0,
                        ),
                        child: Center(
                          child: Text(
                            "No Groups Yet",
                            style: GoogleFonts.roboto(
                              fontSize: 48.0,
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// To Delete Document from Firestore if it hangs
// Cloud.CollectionReference delDoc = Cloud.FirebaseFirestore.instance
//     .collection('${FirebaseAuth.instance.currentUser.uid}');
// await delDoc.doc('Group Payments').delete();
