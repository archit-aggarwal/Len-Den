import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:len_den/widgets/rounded_appbar.dart';
import 'package:len_den/widgets/transaction_data.dart';
import 'add_group_screen.dart';
import 'group_transaction_screen.dart';

class GroupScreen extends StatefulWidget {
  static const String id = 'Group Screen';
  final List<Group> groups = [];

  @override
  _GroupScreen createState() => _GroupScreen();
}

class _GroupScreen extends State<GroupScreen> {
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
                callBack: (newGroup) {
                  setState(() {
                    widget.groups.add(newGroup);
                    print(widget.groups.length);
                  });
                  Navigator.pop(context);
                },
              );
            }),
          );
        },
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RoundedAppBar(
              firstTitle: "Group",
              secondTitle: "Payments",
              pic: 'images/GroupPayment.jpg',
            ),
            (widget.groups.length > 0)
                ? Container(
                    height: 390.0,
                    margin: EdgeInsets.all(20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.groups.length,
                      itemBuilder: (context, index) {
                        final group = widget.groups[index];
                        return Container(
                          width: 200,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                group.groupName,
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline3,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.amber,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: group.groupMembers.length,
                                  itemBuilder: (BuildContext context, int idx) {
                                    return ListTile(
                                      leading: Icon(Icons.account_circle),
                                      title: Text(
                                        group.groupMembers[idx].contact
                                            .displayName,
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
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.blue)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return GroupTransaction(
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
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)),
                                onPressed: () {
                                  setState(() {
                                    widget.groups.removeAt(index);
                                  });
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
      ),
    );
  }
}
