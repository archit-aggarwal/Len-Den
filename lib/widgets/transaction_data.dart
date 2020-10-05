import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'dart:math';

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
  final time;
  final TransactionBook sender;
  final TransactionBook receiver;
}

class TransactionBook {
  TransactionBook(
      {this.contact,
      this.leadingIcon,
      this.isChecked = false,
      this.netAmount = 0});
  Contact contact;
  int netCredit = 0;
  int netDebit = 0;
  int netAmount = 0;
  List<Transaction> transactions = [];
  Widget leadingIcon;
  bool isChecked;

  void addtransaction(Transaction transaction) {
    netCredit += transaction.amountCredit;
    netDebit += transaction.amountDebit;
    netAmount = (netCredit - netDebit);
    transactions.add(transaction);
  }

  void removetransaction(Transaction transaction) {
    netCredit -= transaction.amountCredit;
    netDebit -= transaction.amountDebit;
    netAmount = (netCredit - netDebit);
    transactions.remove(transaction);
  }
}

class Group {
  Group({this.groupName});
  String groupName;
  List<Transaction> transactions = [];
  List<TransactionBook> groupMembers = [];
  List<Transaction> reducedTransactions = [];

  void addGroupMember(TransactionBook transactionBook) {
    groupMembers.add(transactionBook);
  }

  void removeTransaction(int index) {
    int sender = groupMembers.indexWhere((transactionBook) =>
        transactions[index].sender.contact == transactionBook.contact);
    groupMembers[sender].removetransaction(
      Transaction(
        message: transactions[index].message,
        time: transactions[index].time,
        amountDebit: transactions[index].netAmount,
        amountCredit: 0,
      ),
    );
    int receiver = groupMembers.indexWhere((transactionBook) =>
        transactions[index].receiver.contact == transactionBook.contact);
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
          contact: book.contact,
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

  void addTransaction(Transaction transaction) {
    int sender = groupMembers.indexWhere((transactionBook) =>
        transaction.sender.contact == transactionBook.contact);
    groupMembers[sender].addtransaction(
      Transaction(
        message: transaction.message,
        time: transaction.time,
        amountDebit: transaction.netAmount,
        amountCredit: 0,
      ),
    );
    int receiver = groupMembers.indexWhere((transactionBook) =>
        transaction.receiver.contact == transactionBook.contact);

    groupMembers[receiver].addtransaction(
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
        contact: book.contact,
        netAmount: book.netAmount,
        leadingIcon: book.leadingIcon,
      );
      books.add(newBook);
    }
    updateReducedTransactions(books: books);
  }
}
