import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegecoin/cloud/cloud_storage_const.dart';
import 'package:collegecoin/cloud/transac_cloud_storage.dart';
import 'package:collegecoin/cloud/walletcloud.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class WalletCloudStorage{
  final wallet=FirebaseFirestore.instance.collection('wallet');
  
  int limtotal=0;
  List<int> bud=[];
  Future<void> createWallet(String? uid,String? walname,String? amt,String? lim)async {
    wallet.add({
      userIdField:uid,
      walField:walname,
      amtField:amt,
      limField:lim
    });
  }

  Future<Iterable<WalletCloud>> getWallets(String? uid,BuildContext context) async{
    return await wallet.where(userIdField, isEqualTo: uid).get().then(((value) => value.docs.map((doc) => WalletCloud.fromSnapshot(doc))));
  }

  Future<Iterable<WalletCloud>> getMyWallet(String? uid,String walname) async{
    return await wallet.where(userIdField,isEqualTo: uid).where(walField,isEqualTo: walname).get().then(((value) => value.docs.map((doc) => WalletCloud.fromSnapshot(doc))));
  }

  Future<void> updateWalletAmt(String docid,String finalamt) async{
    wallet.doc(docid).update({amtField:finalamt});
  }

  Future<void> updateLimit(String docid,String lim) async{
    wallet.doc(docid).update({limField:lim});
  }

  Future<int> getWalletAmt(String? uid, BuildContext context) async {
    int total=0;
    wallet.where(userIdField,isEqualTo: uid).where(walField, isEqualTo: "Wallet 1").get().then((querySnapshot) {
      for(var docSnap in querySnapshot.docs){
        return (int.parse(docSnap.data()[amtField]));
      }
    });
    return await total;
  }
  Future<int> getLimitAmt(String? uid) async {
    wallet.where(userIdField,isEqualTo: uid).where(walField, isEqualTo: "Wallet 1").get().then((querySnapshot) {
      for(var docSnap in querySnapshot.docs){
        limtotal= int.parse(docSnap.data()[limField]);
        return limtotal;
      }
    });
    return limtotal;
  }
}