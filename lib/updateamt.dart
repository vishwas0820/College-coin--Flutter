import 'package:collegecoin/cloud/walletcloud.dart';
import 'package:flutter/material.dart';

import 'cloud/wallet_cloud_storage.dart';
import 'local_notification_service.dart';

class AddAmtView extends StatefulWidget {
  const AddAmtView({super.key});
  
  @override
  State<AddAmtView> createState() => _AddAmtViewState();
}

class _AddAmtViewState extends State<AddAmtView> {
  late final TextEditingController lim;
  final walService=WalletCloudStorage();
  final service=LocalNotificationService();
  late int newamt;
  @override
  void initState() {
    lim = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    lim.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    WalletCloud ord=ModalRoute.of(context)!.settings.arguments as WalletCloud;
    return Scaffold(
      appBar: AppBar(title: const Text("Add Amount",),centerTitle: true,backgroundColor: Colors.purple[700],),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: lim,
                decoration: const InputDecoration(hintText: 'Amount'),
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () async{
                newamt=int.parse(ord.amt);
                newamt=newamt+int.parse(lim.text);
                walService.updateWalletAmt(ord.docid, newamt.toString());
                await service.showNotification(id: 1, title: "Wallet", body: "Added amt Rs.${lim.text} to ${ord.walname}");
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