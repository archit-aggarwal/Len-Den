import 'package:flutter/material.dart';
import 'package:len_den/screens/homepage_screen.dart';
import 'package:len_den/widgets/transaction_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:len_den/widgets/rounded_appbar.dart';
import 'individual_transaction_screen.dart';

class IndividualScreen extends StatefulWidget {
  static const String id = "Individual Payment Screen";
  @override
  _IndividualScreenState createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  TextEditingController searchController = TextEditingController();
  List<TransactionBook> booksFiltered = [];

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      filterContacts();
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

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            RoundedAppBar(
              firstTitle: "Individual",
              secondTitle: "Payments",
              pic: 'images/IndividualPayment.jpg',
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
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
                  return ListTile(
                    title: Text(transactionBook.contact.displayName),
                    subtitle: Text(transactionBook.contact.phones.length > 0
                        ? transactionBook.contact.phones.elementAt(0).value
                        : ''),
                    leading: transactionBook.leadingIcon,
                    trailing: IconButton(
                      icon: FaIcon(FontAwesomeIcons.rupeeSign),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return IndividualTransaction(
                                transactionBook: transactionBook,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
