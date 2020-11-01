import 'package:collection/collection.dart';
import 'dart:math';
import 'package:len_den/model/transaction.dart';
import 'package:len_den/model/transaction_book.dart';

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
