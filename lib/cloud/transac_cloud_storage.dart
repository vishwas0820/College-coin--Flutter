import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegecoin/cloud/cloud_storage_const.dart';
import 'package:collegecoin/cloud/transaccloud.dart';
import 'package:collegecoin/sector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransacCloudStorage{
  final tra=FirebaseFirestore.instance.collection('transaction');
  final List<Sector> res=[];

  Future<void> createTransac(String? uid,String? walname,String? amt,String? type,String? ei,String? date,String? time, String? desc)async {
    tra.add({
      userIdField:uid,
      walField:walname,
      amtField:amt,
      typeField:type,
      exinField:ei,
      dateField:date,
      timeField:time,
      descField:desc
    });
  }

  Future<Iterable<TransacCloud>> getTransac(String? uid,BuildContext context) async{
    return await tra.where(userIdField, isEqualTo: uid).get().then(((value) => value.docs.map((doc) => TransacCloud.fromSnapshot(doc))));
  }

  Future<Iterable<TransacCloud>> getTransacHome(String? uid,BuildContext context) async{
    return await tra.where(userIdField, isEqualTo: uid).limit(6).get().then(((value) => value.docs.map((doc) => TransacCloud.fromSnapshot(doc))));
  }

  Future<List<Sector>> getGraphData(String? uid) async{
    final List<Sector> list=[];
    await tra.where(userIdField,isEqualTo: uid).where(typeField,isEqualTo: "Shopping ").count().get().then((res) => list.add(Sector(title: "Shopping", value: res.count?.toDouble(),col:Colors.red)));
    await tra.where(userIdField,isEqualTo: uid).where(typeField,isEqualTo: "Travel").count().get().then((res1) => list.add(Sector(title: "Travel", value: res1.count?.toDouble(),col: Colors.blue)));
    await tra.where(userIdField,isEqualTo: uid).where(typeField,isEqualTo: "Food").count().get().then((res2) => list.add(Sector(title: "Food", value: res2.count?.toDouble(),col:Colors.orange)));
    await tra.where(userIdField,isEqualTo: uid).where(typeField,isEqualTo: "Other").count().get().then((res3) => list.add(Sector(title: "Others", value: res3.count?.toDouble(),col: Colors.green)));
    
    /*list.add(Sector(title: "Travel", value: val2.toDouble()));*/
    print("Within func ${list}");
    
    return list;
  }

  Future<int> showStatus(String? uid) async{
    int total=0;
    await tra.where(userIdField,isEqualTo: uid).get().then((value) => value.docs.forEach((doc) {total=total+int.parse(doc[amtField]);}));
    return total;
  }

  Future<Iterable<TransacCloud>> linedata(String? uid, BuildContext context) async{
    return await tra.where(userIdField,isEqualTo: uid).limit(7).get().then((value) => value.docs.map((doc) => TransacCloud.fromSnapshot(doc)));
  }
  
  
}