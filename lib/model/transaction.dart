import 'package:len_den/model/transaction_book.dart';

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
