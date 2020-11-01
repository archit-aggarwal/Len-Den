import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:len_den/model/transaction.dart';

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
