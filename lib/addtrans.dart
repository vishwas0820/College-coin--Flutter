import 'package:collegecoin/cloud/transac_cloud_storage.dart';
import 'package:collegecoin/cloud/wallet_cloud_storage.dart';
import 'package:collegecoin/cloud/walletcloud.dart';
import 'package:collegecoin/local_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum IconLabel {
  food('Food', 'food'),
  shopping(
    'Shopping',
    'shopping',
  ),
  transport('Transportation', 'transport'),
  salary('Salary', 'salary');

  const IconLabel(this.label, this.type);
  final String label;
  final String type;
}

class AddTransac extends StatefulWidget {
  const AddTransac({super.key});

  @override
  State<AddTransac> createState() => _AddTransacState();
}

class _AddTransacState extends State<AddTransac> {
  late final TextEditingController name;
  late final TextEditingController amt;
  late final TextEditingController type;
  late final TextEditingController exin;
  late final TextEditingController desc;
  IconLabel? selLabel;
  
  late final LocalNotificationService service;
  final traService=TransacCloudStorage();
  String? uid=FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    name = TextEditingController();
    amt = TextEditingController();
    type=TextEditingController();
    exin=TextEditingController();
    desc=TextEditingController();
    service=LocalNotificationService();
    service.intialize();
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    amt.dispose();
    type.dispose();
    exin.dispose();
    desc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction",),centerTitle: true,),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: name,
                decoration: const InputDecoration(hintText: 'Wallet Name'),
          ),
          TextField(
                controller: amt,
                decoration: const InputDecoration(hintText: 'Amount'),
          ),
          TextField(
                controller: type,
                decoration: const InputDecoration(hintText: 'Type'),
          ),
          TextField(
                controller: desc,
                decoration: const InputDecoration(hintText: 'Description'),
          ),
          TextField(
                controller: exin,
                decoration: const InputDecoration(hintText: 'Expense/Income'),
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () async{
                update(uid,name.text,amt.text,exin.text);
                DateTime cur=DateTime.now();
                String date="${cur.day}-${cur.month}-${cur.year}";
                String time="${cur.hour}:${cur.minute}";
                traService.createTransac(uid, name.text, amt.text, type.text,exin.text,date,time,desc.text);
                await service.showNotification(id: 0, title: "New Transaction", body: "${amt.text} for ${desc.text} at $time on $date");

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
          ],
        ),
      )
    );
  }
}

void update(String? uid,String walletname,String amt,String exin) async{
  final walService=WalletCloudStorage();
  final service=LocalNotificationService();
  int tot;
  Iterable<WalletCloud> w=await walService.getMyWallet(uid, walletname);
  for(var doc in w){
    int val=int.parse(doc.amt);
    if(exin=='Expense'){
      tot=val-int.parse(amt);
    } else{
      tot=val+int.parse(amt);
    }
    String finalval=tot.toString();
    walService.updateWalletAmt(doc.docid,finalval);
    if(tot<int.parse(doc.limit)){
      await service.showNotification(id: 1, title: "Alert", body: "You have reached limit");
    }
  }
}