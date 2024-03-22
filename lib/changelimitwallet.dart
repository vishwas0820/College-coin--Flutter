import 'package:collegecoin/changelimit.dart';
import 'package:collegecoin/cloud/wallet_cloud_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cloud/walletcloud.dart';
import 'local_notification_service.dart';

class ChangeWalletView extends StatefulWidget {
  const ChangeWalletView({super.key});

  @override
  State<ChangeWalletView> createState() => _ChangeWalletViewState();
}

class _ChangeWalletViewState extends State<ChangeWalletView> {
  final walService=WalletCloudStorage();
  String? uid=FirebaseAuth.instance.currentUser?.uid;
  Iterable<WalletCloud>? ordIds;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Limit",),centerTitle: true,backgroundColor: Colors.purple[700],),
      body: Column(
        children: [
          accdetails(context),
          const SizedBox(height: 8,),
          Expanded(
            child: FutureBuilder(
              future: walService.getWallets(uid, context),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  ordIds=snapshot.data;
                  return ListView.builder(
                    itemCount: ordIds?.length,
                    itemBuilder: ((context, index) {
                      final ord=ordIds?.elementAt(index);
                      return Card(
                        child: ListTile(
                        leading: const Icon(Icons.wallet),
                        title: Text(ord!.walname),
                        trailing: Text('Rs.${ord.amt}'),
                        onTap: () {
                          Navigator.of(context).pushNamed('/changelim/',arguments: ord);
                        },
                        ),
                      );
                  })
                  );
                }
                else{
                  return const Center(child: Text("You haven't added any wallets"));
                }
              },
            ),
          ),
          
        ],
      ),
    );
  }
}

Widget accdetails(BuildContext context){
  return SizedBox(
    height: 162,
    width: double.maxFinite,
    child: Stack(
      children:<Widget> [
        Container(
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: Image.asset(
                'assets/accbg.png',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                
            ),
        ),
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
            Text('Account',style: TextStyle(fontSize: 24,fontWeight: FontWeight.normal),),
          ]),
        )
    ]
    ),
    
  );
}