import 'package:collegecoin/cloud/walletcloud.dart';
import 'package:flutter/material.dart';

import 'cloud/wallet_cloud_storage.dart';
import 'local_notification_service.dart';

class ChangeLimitView extends StatefulWidget {
  const ChangeLimitView({super.key});
  
  @override
  State<ChangeLimitView> createState() => _ChangeLimitViewState();
}

class _ChangeLimitViewState extends State<ChangeLimitView> {
  late final TextEditingController lim;
  final walService=WalletCloudStorage();
  final service=LocalNotificationService();
  
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
      appBar: AppBar(title: const Text("Change Limit",),centerTitle: true,backgroundColor: Colors.purple[700],),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: lim,
                decoration: const InputDecoration(hintText: 'New Limit'),
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () async{
                walService.updateLimit(ord.docid, lim.text);
                await service.showNotification(id: 0, title: "Limit Change", body: "Changed limit to ${lim.text}");
                Navigator.pushNamedAndRemoveUntil(context, '/home/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.purple,
                backgroundColor: Colors.blueGrey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Change'),
          ),)
          ],
        ),
      )
    );
  }
}