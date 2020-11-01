import 'package:flutter/material.dart';
import 'package:len_den/model/transaction_book.dart';
import 'package:len_den/screens/group_payment_screen.dart';
import 'package:len_den/screens/history_screen.dart';
import 'package:len_den/screens/individual_payments_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class HomePage extends StatefulWidget {
  static List<TransactionBook> transactionBooks = [];
  static const String id = 'Home Page Screen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      List<Contact> _contacts = (await ContactsService.getContacts()).toList();
      List colors = [
        Colors.green,
        Colors.indigo,
        Colors.yellow,
        Colors.orange,
        Colors.blue,
      ];
      int colorIndex = 0;
      List<TransactionBook> _transactionBooks = [];
      for (var contact in _contacts) {
        Widget leadingIcon =
            (contact.avatar != null && contact.avatar.length > 0)
                ? CircleAvatar(
                    backgroundImage: MemoryImage(contact.avatar),
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        colors[colorIndex][800],
                        colors[colorIndex][400],
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                    ),
                    child: CircleAvatar(
                        child: Text(
                          contact.initials(),
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.transparent),
                  );
        _transactionBooks.add(
          TransactionBook(contact: contact, leadingIcon: leadingIcon),
        );
        colorIndex = (colorIndex + 1) % 4;
      }
      setState(() {
        HomePage.transactionBooks = _transactionBooks;
      });
    }
  }

  int _selectedIndex = 1;
  List<Widget> _widgetOptions = <Widget>[
    IndividualScreen(),
    HistoryScreen(),
    GroupScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SnakeNavigationBar.color(
        snakeViewColor: Colors.white,
        backgroundColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userFriends),
            // ignore: deprecated_member_use
            title: Text('Individual'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userClock),
            // ignore: deprecated_member_use
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.users),
            // ignore: deprecated_member_use
            title: Text('Group'),
          ),
        ],
      ),
    );
  }
}
