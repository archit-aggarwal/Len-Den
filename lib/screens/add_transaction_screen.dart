import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:len_den/model/transaction.dart';
import 'package:len_den/widgets/reusable_card.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

enum Payment {
  Credit,
  Debit,
}

class AddTransactionScreen extends StatefulWidget {
  static const String id = 'Add Transaction Screen';
  AddTransactionScreen(this.callBack);
  final Function callBack;

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String message = "";
  Payment paymentType = Payment.Credit;
  int amount;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        // alignment: Alignment.topCenter,
        child: Column(
          children: [
            Container(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: ReusableCard(
                      onPress: () {
                        setState(() {
                          paymentType = Payment.Debit;
                        });
                      },
                      colour: paymentType == Payment.Credit
                          ? Colors.white12
                          : Colors.red,
                      cardChild: IconContent(
                        icon: Icons.redo,
                        color: Colors.orange,
                        label: 'Debit',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      onPress: () {
                        setState(() {
                          paymentType = Payment.Credit;
                        });
                      },
                      colour: paymentType == Payment.Debit
                          ? Colors.white12
                          : Colors.green,
                      cardChild: IconContent(
                        icon: Icons.undo,
                        color: Colors.greenAccent,
                        label: 'Credit',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
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
                          labelText: "Message",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          prefixIcon: Icon(FontAwesomeIcons.commentDots,
                              color: Colors.white),
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Message cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (newText) {
                          message = newText;
                        },
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      child: TextFormField(
                        // initialValue: message,
                        decoration: InputDecoration(
                          labelText: "Transaction Amount",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          prefixIcon: Icon(FontAwesomeIcons.rupeeSign,
                              color: Colors.white),
                        ),
                        validator: (input) {
                          final isDigitsOnly = int.tryParse(input);
                          return isDigitsOnly == null
                              ? 'Transaction Amount needs to be digits only'
                              : ((int.parse(input) <= 0)
                                  ? 'Transaction Amount Should be Positive'
                                  : null);
                        },
                        onChanged: (newAmount) {
                          final isDigitsOnly = int.tryParse(newAmount);
                          if (isDigitsOnly != null && int.parse(newAmount) > 0)
                            amount = int.parse(newAmount);
                        },
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          int amountDebit = 0, amountCredit = 0;
                          if (paymentType == Payment.Credit)
                            amountCredit = amount;
                          else
                            amountDebit = amount;
                          Transaction transaction = new Transaction(
                            amountCredit: amountCredit,
                            amountDebit: amountDebit,
                            time: DateTime.now(),
                            message: message,
                          );
                          await widget.callBack(transaction);
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
