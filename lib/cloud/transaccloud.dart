import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'cloud_storage_const.dart';

@immutable
class TransacCloud{
  final String docid;
  final String userid;
  final String walname;
  final String amt;
  final String type;
  final String exin;
  final String date;
  final String time;
  final String desc;

  const TransacCloud({required this.docid,required this.userid,required this.walname,required this.amt,required this.type,required this.exin,required this.date,required this.time,required this.desc});

  TransacCloud.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
    docid=snapshot.id,
    walname=snapshot.data()[walField],
    userid=snapshot.data()[userIdField],
    amt=snapshot.data()[amtField],
    type=snapshot.data()[typeField],
    exin=snapshot.data()[exinField],
    date=snapshot.data()[dateField],
    time=snapshot.data()[timeField],
    desc=snapshot.data()[descField];
}