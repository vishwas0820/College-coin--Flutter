import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'cloud_storage_const.dart';

@immutable
class WalletCloud{
  final String docid;
  final String userid;
  final String walname;
  final String amt;
  final String limit;

  const WalletCloud({required this.docid,required this.userid,required this.walname,required this.amt,required this.limit});

  WalletCloud.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
    docid=snapshot.id,
    walname=snapshot.data()[walField],
    userid=snapshot.data()[userIdField],
    amt=snapshot.data()[amtField],
    limit=snapshot.data()[limField];
}