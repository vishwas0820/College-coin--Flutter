import 'package:collegecoin/cloud/wallet_cloud_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({super.key});

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  late final TextEditingController name;
  late final TextEditingController amt;
  late final TextEditingController limit;
  final walService=WalletCloudStorage();
  String? uid=FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    name = TextEditingController();
    amt = TextEditingController();
    limit=TextEditingController();
    super.initState();
  }

  @override
  @override
  void dispose() {
    name.dispose();
    amt.dispose();
    limit.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Wallet'),backgroundColor: Colors.purple[700],),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
                controller: name,
                decoration: const InputDecoration(hintText: 'Name'),
          ),
          TextField(
                controller: amt,
                decoration: const InputDecoration(hintText: 'Amount'),
          ),
          TextField(
                controller: limit,
                decoration: const InputDecoration(hintText: 'Limit'),
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () async{
                walService.createWallet(uid, name.text, amt.text, limit.text);
                Navigator.pushNamedAndRemoveUntil(context, '/home/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.purple,
                backgroundColor: Colors.blueGrey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add'),
          ),)
        ],),
      )
    );
  }
}