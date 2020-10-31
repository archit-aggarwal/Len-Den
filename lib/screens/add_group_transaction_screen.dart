import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:len_den/widgets/transaction_data.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class AddGroupTransactionScreen extends StatefulWidget {
  static const String id = 'Add Transaction Screen';
  AddGroupTransactionScreen({this.group, this.callBack});
  final Function callBack;
  final Group group;

  @override
  _AddGroupTransactionScreenState createState() =>
      _AddGroupTransactionScreenState();
}

class _AddGroupTransactionScreenState extends State<AddGroupTransactionScreen> {
  String message = "";
  int amount = 0;
  int chosenSender, chosenReceiver;
  final _formKey = GlobalKey<FormState>();
  List<Map> members = [];

  @override
  void initState() {
    super.initState();
    int count = 0;
    setState(() {
      for (var member in widget.group.groupMembers) {
        var createMap = {
          'display': member.contactName,
          'value': count,
        };
        count++;
        members.add(createMap);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.all(10),
                child: DropDownFormField(
                  titleText: 'Sender',
                  hintText: 'Please choose one',
                  value: chosenSender,
                  onSaved: (value) {
                    setState(() {
                      chosenSender = value;
                    });
                  },
                  onChanged: (int value) {
                    setState(() {
                      chosenSender = value;
                    });
                  },
                  dataSource: members,
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.all(10),
                child: DropDownFormField(
                  titleText: 'Receiver',
                  hintText: 'Please choose one',
                  value: chosenReceiver,
                  onSaved: (value) {
                    setState(() {
                      chosenReceiver = value;
                    });
                  },
                  onChanged: (int value) {
                    setState(() {
                      chosenReceiver = value;
                    });
                  },
                  dataSource: members,
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
              SizedBox(height: 20.0),
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
                    prefixIcon:
                        Icon(FontAwesomeIcons.commentDots, color: Colors.white),
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Message cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (newText) {
                    if (newText.length > 0) {
                      message = newText;
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.poppins(),
                ),
              ),
              SizedBox(height: 20.0),
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
                    prefixIcon:
                        Icon(FontAwesomeIcons.rupeeSign, color: Colors.white),
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
                    if (isDigitsOnly != null && int.parse(newAmount) > 0) {
                      amount = int.parse(newAmount);
                    }
                  },
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(),
                ),
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Transaction transaction = Transaction(
                      sender: widget.group.groupMembers[chosenSender],
                      receiver: widget.group.groupMembers[chosenReceiver],
                      time: DateTime.now(),
                      message: message,
                      netAmount: amount,
                    );
                    widget.callBack(transaction);
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
