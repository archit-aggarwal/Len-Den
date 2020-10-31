import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:len_den/widgets/transaction_data.dart';
import 'homepage_screen.dart';

class AddGroupScreen extends StatefulWidget {
  AddGroupScreen({this.callBack});
  final Function callBack;
  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  String currentName;
  TextEditingController searchController = TextEditingController();
  List<TransactionBook> booksFiltered = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      for (var transactionBook in HomePage.transactionBooks) {
        transactionBook.isChecked = false;
      }
    });
    searchController.addListener(() {
      filterContacts();
    });
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContacts() {
    List<TransactionBook> _booksFiltered = [];
    _booksFiltered.addAll(HomePage.transactionBooks);

    if (searchController.text.isNotEmpty) {
      _booksFiltered.retainWhere((transactionBook) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = transactionBook.contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }
        if (searchTermFlatten.isEmpty) {
          return false;
        }
        var phone = transactionBook.contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);
        return phone != null;
      });
    }
    setState(() {
      booksFiltered = _booksFiltered;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Group Name",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                    ),
                    validator: (name) {
                      if (name.length == 0) return 'Please Enter Group Name';
                      Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(name))
                        return 'Invalid Group Name';
                      else
                        return null;
                    },
                    onChanged: (newText) {
                      setState(() {
                        currentName = newText;
                      });
                    },
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.poppins(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Member',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      thickness: 1.5,
                      height: 5,
                      color: Colors.white12,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    shrinkWrap: true,
                    itemCount: isSearching == false
                        ? HomePage.transactionBooks.length
                        : booksFiltered.length,
                    itemBuilder: (context, index) {
                      TransactionBook transactionBook = isSearching == false
                          ? HomePage.transactionBooks[index]
                          : booksFiltered[index];
                      return CheckboxListTile(
                        value: transactionBook.isChecked,
                        title: Text(transactionBook.contact.displayName),
                        subtitle: Text(transactionBook.contact.phones.length > 0
                            ? transactionBook.contact.phones.elementAt(0).value
                            : ''),
                        secondary: transactionBook.leadingIcon,
                        onChanged: (bool value) {
                          setState(() {
                            transactionBook.isChecked = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      List<TransactionBook> groupMembers = [];
                      for (var transactionBook in HomePage.transactionBooks) {
                        if (transactionBook.isChecked == true) {
                          groupMembers.add(
                            TransactionBook(
                              leadingIcon: transactionBook.leadingIcon,
                              contact: transactionBook.contact,
                              contactName: transactionBook.contact.displayName,
                              contactNumber:
                                  (transactionBook.contact.phones.length > 0)
                                      ? transactionBook
                                          .contact.phones.first.value
                                      : "",
                            ),
                          );
                        }
                      }
                      Group newGroup = Group(
                        groupName: currentName,
                        timeCreated: DateTime.now(),
                        groupMembers: groupMembers,
                      );
                      await widget.callBack(newGroup);
                    }
                  },
                  child: Text('Add Group'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
