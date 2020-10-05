import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:len_den/widgets/transaction_data.dart';
import 'package:intl/intl.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'add_group_transaction_screen.dart';

class GroupTransaction extends StatefulWidget {
  GroupTransaction({this.group});
  final Group group;
  @override
  _GroupTransactionState createState() => _GroupTransactionState();
}

class _GroupTransactionState extends State<GroupTransaction> {
  int _selectedIndex = 0;

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
                  return AddGroupTransactionScreen(
                    group: widget.group,
                    callBack: (newTransaction) {
                      setState(() {
                        widget.group.addTransaction(newTransaction);
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
                  widget.group.groupName,
                  style: GoogleFonts.blackOpsOne(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xff03DAC6),
                      letterSpacing: .5,
                    ),
                  ),
                ),
                background: Container(
                  width: double.infinity,
                  decoration: new BoxDecoration(
                    // color: Colors.orange,
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6), BlendMode.dstATop),
                      image: AssetImage((_selectedIndex == 0)
                          ? 'images/OriginalPayment.jpeg'
                          : 'images/MinimizePayment.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            (_selectedIndex == 0)
                ? (widget.group.transactions.length > 0)
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  widget.group.removeTransaction(index);
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                height: 150,
                                width: double.maxFinite,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: widget
                                                      .group
                                                      .transactions[index]
                                                      .sender
                                                      .leadingIcon,
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Container(
                                                  width: 80,
                                                  child: AutoSizeText(
                                                    widget
                                                        .group
                                                        .transactions[index]
                                                        .sender
                                                        .contact
                                                        .displayName,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts
                                                        .robotoCondensed(),
                                                  ),
                                                ),
                                                Container(
                                                  width: 80,
                                                  child: AutoSizeText(
                                                    widget
                                                                .group
                                                                .transactions[
                                                                    index]
                                                                .sender
                                                                .contact
                                                                .phones
                                                                .length >
                                                            0
                                                        ? widget
                                                            .group
                                                            .transactions[index]
                                                            .sender
                                                            .contact
                                                            .phones
                                                            .elementAt(0)
                                                            .value
                                                        : '',
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts
                                                        .robotoCondensed(
                                                            fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            FaIcon(
                                              FontAwesomeIcons.arrowRight,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    " ${widget.group.transactions[index].netAmount} ${String.fromCharCodes(
                                                      Runes(' \u{20B9}'),
                                                    )} ",
                                                    style: TextStyle(
                                                        color: Colors.amber),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  DateFormat('kk:mm').format(
                                                      widget
                                                          .group
                                                          .transactions[index]
                                                          .time),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(widget
                                                          .group
                                                          .transactions[index]
                                                          .time),
                                                ),
                                              ],
                                            ),
                                            FaIcon(
                                              FontAwesomeIcons.arrowRight,
                                              color: Colors.green,
                                              size: 30,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: widget
                                                      .group
                                                      .transactions[index]
                                                      .receiver
                                                      .leadingIcon,
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Container(
                                                  width: 80,
                                                  child: AutoSizeText(
                                                    widget
                                                        .group
                                                        .transactions[index]
                                                        .receiver
                                                        .contact
                                                        .displayName,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts
                                                        .robotoCondensed(),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: AutoSizeText(
                                                    widget
                                                                .group
                                                                .transactions[
                                                                    index]
                                                                .receiver
                                                                .contact
                                                                .phones
                                                                .length >
                                                            0
                                                        ? widget
                                                            .group
                                                            .transactions[index]
                                                            .receiver
                                                            .contact
                                                            .phones
                                                            .elementAt(0)
                                                            .value
                                                        : '',
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts
                                                        .robotoCondensed(
                                                            fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 6),
                                          child: AutoSizeText(
                                            '\"${widget.group.transactions[index].message}\"',
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.lightBlueAccent,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: widget.group.transactions.length,
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "No Transactions Yet",
                              style: GoogleFonts.roboto(
                                fontSize: 32.0,
                                color: Colors.amber,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      )
                : (widget.group.reducedTransactions.length > 0)
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              height: 150,
                              width: double.maxFinite,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: widget
                                                .group
                                                .reducedTransactions[index]
                                                .sender
                                                .leadingIcon,
                                          ),
                                          SizedBox(height: 6),
                                          Container(
                                            width: 80,
                                            child: AutoSizeText(
                                              widget
                                                  .group
                                                  .reducedTransactions[index]
                                                  .sender
                                                  .contact
                                                  .displayName,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  GoogleFonts.robotoCondensed(),
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            child: AutoSizeText(
                                              widget
                                                          .group
                                                          .reducedTransactions[
                                                              index]
                                                          .sender
                                                          .contact
                                                          .phones
                                                          .length >
                                                      0
                                                  ? widget
                                                      .group
                                                      .reducedTransactions[
                                                          index]
                                                      .sender
                                                      .contact
                                                      .phones
                                                      .elementAt(0)
                                                      .value
                                                  : '',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.arrowRight,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                      Container(
                                        child: Text(
                                          " ${widget.group.reducedTransactions[index].netAmount} ${String.fromCharCodes(
                                            Runes(' \u{20B9}'),
                                          )} ",
                                          style: TextStyle(color: Colors.amber),
                                        ),
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.arrowRight,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: widget
                                                .group
                                                .reducedTransactions[index]
                                                .receiver
                                                .leadingIcon,
                                          ),
                                          SizedBox(height: 6),
                                          Container(
                                            width: 80,
                                            child: AutoSizeText(
                                              widget
                                                  .group
                                                  .reducedTransactions[index]
                                                  .receiver
                                                  .contact
                                                  .displayName,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  GoogleFonts.robotoCondensed(),
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            child: AutoSizeText(
                                              widget
                                                          .group
                                                          .reducedTransactions[
                                                              index]
                                                          .receiver
                                                          .contact
                                                          .phones
                                                          .length >
                                                      0
                                                  ? widget
                                                      .group
                                                      .reducedTransactions[
                                                          index]
                                                      .receiver
                                                      .contact
                                                      .phones
                                                      .elementAt(0)
                                                      .value
                                                  : '',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: widget.group.reducedTransactions.length,
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "No Transactions Yet or All Transactions Settled",
                              style: GoogleFonts.roboto(
                                fontSize: 32.0,
                                color: Colors.amber,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      )
          ],
        ),
      ),
      bottomNavigationBar: SnakeNavigationBar(
        snakeColor: Colors.white,
        backgroundColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onPositionChanged: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.sitemap),
            // ignore: deprecated_member_use
            title: Text('Complex Payments'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.projectDiagram),
            // ignore: deprecated_member_use
            title: Text('Minimized Payments'),
          )
        ],
      ),
    );
  }
}
