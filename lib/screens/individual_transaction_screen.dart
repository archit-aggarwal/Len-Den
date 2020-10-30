import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:len_den/screens/add_transaction_screen.dart';
import 'package:len_den/widgets/something_went_wrong.dart';
import 'package:len_den/widgets/transaction_data.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as Cloud;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class IndividualTransaction extends StatefulWidget {
  IndividualTransaction({this.transactionBook});
  final TransactionBook transactionBook;
  static const String id = "Individual Transaction Screen";

  @override
  _IndividualTransactionState createState() => _IndividualTransactionState();
}

class _IndividualTransactionState extends State<IndividualTransaction> {
  Cloud.CollectionReference transactions;
  Future<void> addTransaction(Transaction transaction) async {
    var netDoc = await Cloud.FirebaseFirestore.instance
        .doc("${widget.transactionBook.contact.displayName}/netAmount")
        .get();
    Cloud.FirebaseFirestore.instance
        .doc("${widget.transactionBook.contact.displayName}/netAmount")
        .set({
      "netAmount": netDoc['netAmount'] +
          transaction.amountCredit -
          transaction.amountDebit,
      "netCredit": netDoc['netCredit'] + transaction.amountCredit,
      "netDebit": netDoc['netDebit'] + transaction.amountDebit,
      "time": DateTime.utc(3000), // To Sort to Top
    }, Cloud.SetOptions(merge: true));
    return transactions
        .add({
          'amountCredit': transaction.amountCredit,
          'amountDebit': transaction.amountDebit,
          'time': transaction.time,
          'message': transaction.message,
        })
        .then((value) => CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: "Transaction Added Successfully",
            ))
        .catchError((error) => CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "Failed to add Transaction: $error",
            ));
  }

  Future checkExist() async {
    try {
      await Cloud.FirebaseFirestore.instance
          .doc("${widget.transactionBook.contact.displayName}/netAmount")
          .get()
          .then((doc) {
        if (doc.exists == false)
          Cloud.FirebaseFirestore.instance
              .doc("${widget.transactionBook.contact.displayName}/netAmount")
              .set({
            "netAmount": 0,
            "netCredit": 0,
            "netDebit": 0,
            "time": DateTime.utc(3000), // Oldest Date & Time
          });
      });
    } catch (e) {
      Cloud.FirebaseFirestore.instance
          .doc("${widget.transactionBook.contact.displayName}/netAmount")
          .set({
        "netAmount": 0,
        "netCredit": 0,
        "netDebit": 0,
        "time": DateTime.utc(3000), // Oldest Date & Time
      });
    }
  }

  @override
  void initState() {
    transactions = Cloud.FirebaseFirestore.instance
        .collection(widget.transactionBook.contact.displayName);
    checkExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Cloud.QuerySnapshot>(
        stream: transactions.orderBy('time').snapshots(),
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

          return SliverFab(
            floatingWidget: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AddTransactionScreen(
                      (newTransaction) {
                        addTransaction(newTransaction);
                        Navigator.pop(context);
                      },
                    );
                  }),
                );
              },
              child: Icon(FontAwesomeIcons.plus),
            ),
            floatingPosition: FloatingPosition(right: 16),
            expandedHeight: 256.0,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 256.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.transactionBook.contact.displayName,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white60,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  background: Container(
                    padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 50.0),
                    child: widget.transactionBook.leadingIcon,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Cloud.DocumentSnapshot ds = snapshot
                        .data.docs[snapshot.data.docs.length - index - 1];
                    return (ds.id == 'netAmount')
                        ? ListTile(
                            title: FlipCard(
                              front: Container(
                                margin:
                                    EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.greenAccent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                width: 100,
                                height: 75,
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.only(
                                      top: 8.0,
                                    ),
                                    child: Text(
                                      '${ds['netCredit'].toString()}${String.fromCharCodes(Runes(' '
                                          '\u{20B9}'))}',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 28,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  title: Container(
                                    padding: EdgeInsets.only(
                                      top: 8.0,
                                    ),
                                    child: Text(
                                      'Net Credit',
                                      style: GoogleFonts.roboto(
                                        fontSize: 28,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              back: Container(
                                margin:
                                    EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.deepOrange,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                width: 100,
                                height: 75,
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.only(
                                      top: 8.0,
                                    ),
                                    child: Text(
                                      '${ds['netDebit'].toString()}${String.fromCharCodes(Runes(' \u{20B9}'))}',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  title: Container(
                                    padding: EdgeInsets.only(
                                      top: 8.0,
                                    ),
                                    child: Text(
                                      'Net Debit',
                                      style: GoogleFonts.roboto(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : ListTile(
                            onLongPress: () async {
                              var netDoc = await Cloud
                                  .FirebaseFirestore.instance
                                  .doc(
                                      "${widget.transactionBook.contact.displayName}/netAmount")
                                  .get();
                              Cloud.FirebaseFirestore.instance
                                  .doc(
                                      "${widget.transactionBook.contact.displayName}/netAmount")
                                  .set({
                                "netAmount": netDoc['netAmount'] +
                                    ds['amountCredit'] -
                                    ds['amountDebit'],
                                "netCredit":
                                    netDoc['netCredit'] + ds['amountCredit'],
                                "netDebit":
                                    netDoc['netDebit'] + ds['amountDebit'],
                                "time": DateTime.utc(3000), // To Sort to Top
                              }, Cloud.SetOptions(merge: true));
                              transactions.doc(ds.id).delete();
                            },
                            leading: (ds['amountCredit'] > 0)
                                ? Icon(
                                    Icons.undo,
                                    color: Colors.green,
                                    //size: 24.0,
                                    semanticLabel: 'Credit',
                                  )
                                : Icon(
                                    Icons.redo,
                                    color: Colors.red,
                                    // size: 24.0,
                                    semanticLabel: 'Debit',
                                  ),
                            title: Text(ds['message']),
                            subtitle: Text(
                              DateFormat('kk:mm dd-MM-yyyy')
                                  .format(ds['time'].toDate()),
                            ),
                            trailing: (ds['amountCredit'] > 0)
                                ? Text(
                                    '${ds['amountCredit'].toString()} ${String.fromCharCodes(Runes(' \u{20B9}'))}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 24.0,
                                    ),
                                  )
                                : Text(
                                    '${ds['amountDebit'].toString()} ${String.fromCharCodes(Runes(' \u{20B9}'))}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24.0,
                                    ),
                                  ),
                          );
                  },
                  childCount: snapshot.data.docs.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
