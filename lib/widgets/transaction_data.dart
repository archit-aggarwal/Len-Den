import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'dart:math';

class TransactionBook {
  TransactionBook(
      {this.contact,
      this.contactName,
      this.contactNumber,
      this.leadingIcon,
      this.isChecked = false,
      this.netAmount = 0,
      this.netDebit = 0,
      this.netCredit = 0});
  Contact contact;
  String contactName;
  String contactNumber;
  int netCredit = 0;
  int netDebit = 0;
  int netAmount = 0;
  Widget leadingIcon;
  bool isChecked = false;

  factory TransactionBook.fromJson(Map<String, dynamic> json) {
    // Contact tempContact = Contact.fromMap(json['contact']);
    return TransactionBook(
      netAmount: json['netAmount'],
      // contact: tempContact,
      contactName: json['contactName'],
      contactNumber: json['contactNumber'],
      isChecked: json['isChecked'],
      netCredit: json['netCredit'],
      netDebit: json['netDebit'],
    );
  }

  Map<String, dynamic> toJson() {
    // Map<String, dynamic> contact =
    //     (this.contact != null) ? Map.from(this.contact.toMap()) : null;
    // print(contact);
    // Main Culprit Causing Error Map.from() required
    // Could Not Convert InternalHashMap to Map without Map.from()
    return {
      'netAmount': this.netAmount,
      'contactName': this.contactName,
      'contactNumber': this.contactNumber,
      'isChecked': this.isChecked,
      'netCredit': this.netCredit,
      'netDebit': this.netDebit,
    };
  }

  void addtransaction(Transaction transaction) {
    netCredit += transaction.amountCredit;
    netDebit += transaction.amountDebit;
    netAmount = (netCredit - netDebit);
  }

  void removetransaction(Transaction transaction) {
    netCredit -= transaction.amountCredit;
    netDebit -= transaction.amountDebit;
    netAmount = (netCredit - netDebit);
  }
}

class Transaction {
  Transaction({
    this.amountCredit = 0,
    this.amountDebit = 0,
    this.time,
    this.message = "",
    this.sender,
    this.receiver,
    this.netAmount = 0,
  });

  final int amountCredit;
  final int amountDebit;
  final int netAmount;
  final String message;
  final DateTime time;
  final TransactionBook sender;
  final TransactionBook receiver;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        amountCredit: json['amountCredit'],
        amountDebit: json['amountDebit'],
        netAmount: json['netAmount'],
        message: json['message'],
        sender: TransactionBook.fromJson(json['sender']),
        receiver: TransactionBook.fromJson(json['receiver']),
        time: json['time'] != null ? json['time'].toDate() : null);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> sender =
        (this.sender != null) ? this.sender.toJson() : null;
    Map<String, dynamic> receiver =
        (this.receiver != null) ? this.receiver.toJson() : null;
    return {
      'amountCredit': amountCredit,
      'amountDebit': amountDebit,
      'netAmount': netAmount,
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'time': time,
    };
  }
}

class Group {
  Group({
    this.groupName,
    this.groupMembers,
    this.timeCreated,
    transactions,
    reducedTransactions,
  })  : this.transactions = transactions ?? [],
        this.reducedTransactions = reducedTransactions ?? [];

  String groupName;
  DateTime timeCreated;
  List<Transaction> transactions = [];
  List<TransactionBook> groupMembers;
  List<Transaction> reducedTransactions = [];

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        groupName: json['groupName'],
        timeCreated: json['time'].toDate(),
        transactions: (json['transactions'])
            .map<Transaction>((i) => Transaction.fromJson(i))
            .toList(),
        groupMembers: (json['groupMembers'])
            .map<TransactionBook>((i) => TransactionBook.fromJson(i))
            .toList(),
        reducedTransactions: (json['reducedTransactions'])
            .map<Transaction>((i) => Transaction.fromJson(i))
            .toList());
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> transactions = (this.transactions != null)
        ? this.transactions.map((i) => i.toJson()).toList()
        : null;
    List<Map<String, dynamic>> reducedTransactions =
        (this.reducedTransactions != null)
            ? this.reducedTransactions.map((i) => i.toJson()).toList()
            : null;

    List<Map<String, dynamic>> groupMembers = (this.groupMembers != null)
        ? this.groupMembers.map((i) => i.toJson()).toList()
        : null;

    return {
      'groupName': this.groupName,
      'time': this.timeCreated,
      'transactions': transactions,
      'groupMembers': groupMembers,
      'reducedTransactions': reducedTransactions,
    };
  }

  void addTransaction(Transaction transaction) {
    int senderIndex = groupMembers.indexWhere((transactionBook) =>
        transaction.sender.contactName == transactionBook.contactName);
    groupMembers[senderIndex].addtransaction(
      Transaction(
        message: transaction.message,
        time: transaction.time,
        amountDebit: transaction.netAmount,
        amountCredit: 0,
      ),
    );

    int receiverIndex = groupMembers.indexWhere((transactionBook) =>
        transaction.receiver.contactName == transactionBook.contactName);

    groupMembers[receiverIndex].addtransaction(
      Transaction(
        message: transaction.message,
        time: transaction.time,
        amountCredit: transaction.netAmount,
        amountDebit: 0,
      ),
    );
    transactions.add(transaction);
    reducedTransactions.clear();
    List<TransactionBook> books = [];
    for (TransactionBook book in groupMembers) {
      TransactionBook newBook = new TransactionBook(
        contactName: book.contactName,
        contactNumber: book.contactNumber,
        netAmount: book.netAmount,
        leadingIcon: book.leadingIcon,
      );
      books.add(newBook);
    }
    updateReducedTransactions(books: books);
  }

  void removeTransaction(int index) {
    int sender = groupMembers.indexWhere((transactionBook) =>
        transactions[index].sender.contactName == transactionBook.contactName);
    groupMembers[sender].removetransaction(
      Transaction(
        message: transactions[index].message,
        time: transactions[index].time,
        amountDebit: transactions[index].netAmount,
        amountCredit: 0,
      ),
    );
    int receiver = groupMembers.indexWhere((transactionBook) =>
        transactions[index].receiver.contactName ==
        transactionBook.contactName);
    groupMembers[receiver].removetransaction(
      Transaction(
        message: transactions[index].message,
        time: transactions[index].time,
        amountCredit: transactions[index].netAmount,
        amountDebit: 0,
      ),
    );
    transactions.removeAt(index);
    reducedTransactions.clear();
    List<TransactionBook> books = [];
    for (TransactionBook book in groupMembers) {
      TransactionBook newBook = new TransactionBook(
          contactName: book.contactName,
          contactNumber: book.contactNumber,
          netAmount: book.netAmount,
          leadingIcon: book.leadingIcon);
      books.add(newBook);
    }
    updateReducedTransactions(books: books);
  }

  void updateReducedTransactions({List<TransactionBook> books}) {
    PriorityQueue<TransactionBook> receivers =
        new PriorityQueue((a, b) => b.netAmount.compareTo(a.netAmount));
    PriorityQueue<TransactionBook> senders =
        new PriorityQueue((a, b) => a.netAmount.compareTo(b.netAmount));
    for (var transactionBook in books) {
      if (transactionBook.netAmount > 0)
        receivers.add(transactionBook);
      else if (transactionBook.netAmount < 0) senders.add(transactionBook);
    }
    while (receivers.isNotEmpty && senders.isNotEmpty) {
      TransactionBook receiver = receivers.first;
      TransactionBook sender = senders.first;
      int settlementAmount = min(-sender.netAmount, receiver.netAmount);

      receivers.removeFirst();
      senders.removeFirst();

      reducedTransactions.add(
        Transaction(
          receiver: receiver,
          sender: sender,
          netAmount: settlementAmount,
        ),
      );

      receiver.netAmount -= settlementAmount;
      sender.netAmount += settlementAmount;

      if (receiver.netAmount != 0) receivers.add(receiver);
      if (sender.netAmount != 0) senders.add(sender);
    }
  }
}
