import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:len_den/screens/add_transaction_screen.dart';
import 'package:len_den/widgets/transaction_data.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IndividualTransaction extends StatefulWidget {
  IndividualTransaction({this.transactionBook, this.index
      // this.callBack
      });
  final TransactionBook transactionBook;
  final int index;
  // final Function callBack;
  static const String id = "Individual Transaction Screen";

  @override
  _IndividualTransactionState createState() => _IndividualTransactionState();
}

class _IndividualTransactionState extends State<IndividualTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => SliverFab(
          floatingWidget: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return AddTransactionScreen(
                    (newTransaction) {
                      setState(() {
                        widget.transactionBook.addtransaction(newTransaction);
                      });
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
            SliverToBoxAdapter(
              child: FlipCard(
                front: Container(
                  margin: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
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
                        '${widget.transactionBook.netCredit.toString()}${String.fromCharCodes(Runes(' \u{20B9}'))}',
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
                  margin: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.deepOrange,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
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
                        '${widget.transactionBook.netDebit.toString()}${String.fromCharCodes(Runes(' \u{20B9}'))}',
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
            ),
            (widget.transactionBook.transactions.length > 0)
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final transaction = widget.transactionBook.transactions[
                            widget.transactionBook.transactions.length -
                                (index + 1)];
                        return ListTile(
                          onLongPress: () {
                            setState(() {
                              widget.transactionBook.transactions
                                  .removeAt(index);
                            });
                          },
                          leading: (transaction.amountCredit > 0)
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
                          title: Text(transaction.message),
                          subtitle: Text(
                            DateFormat('kk:mm dd-MM-yyyy')
                                .format(transaction.time),
                          ),
                          trailing: (transaction.amountCredit > 0)
                              ? Text(
                                  '${transaction.amountCredit.toString()} ${String.fromCharCodes(Runes(' \u{20B9}'))}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 24.0,
                                  ),
                                )
                              : Text(
                                  '${transaction.amountDebit.toString()} ${String.fromCharCodes(Runes(' \u{20B9}'))}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 24.0,
                                  ),
                                ),
                        );
                      },
                      childCount: widget.transactionBook.transactions.length,
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Expanded(
                      child: Center(
                        child: Text(
                          "No Transactions Yet",
                          style: GoogleFonts.roboto(
                            fontSize: 32.0,
                            fontStyle: FontStyle.italic,
                          ),
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
