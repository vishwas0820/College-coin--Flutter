import 'package:collegecoin/changelimit.dart';
import 'package:collegecoin/cloud/wallet_cloud_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cloud/walletcloud.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final walService=WalletCloudStorage();
  String? uid=FirebaseAuth.instance.currentUser?.uid;
  Iterable<WalletCloud>? ordIds;
  late Iterable<WalletCloud> wals;
  int tot=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account",),centerTitle: true,backgroundColor: Colors.purple[700],),
      body: Column(
        children: [
          SizedBox(
            child: FutureBuilder(
              future: walService.getWallets(uid, context),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  wals=snapshot.data!;
                  for(final v1 in wals){
                    tot=tot+int.parse(v1.amt);
                  }
                  return accdetails(context,tot);
                } else {
                  return const Text("Loading");
                }
              },
            )
            
          ),
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
                          Navigator.of(context).pushNamed('/addamt/',arguments: ord);
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
      bottomNavigationBar: SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () async{
                Navigator.pushNamedAndRemoveUntil(context, '/addwallet/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.purple,
                backgroundColor: Colors.blueGrey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('+ Add new wallet'),
            ),
          ),
    );
  }
}

Widget accdetails(BuildContext context, int tot){
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
            children:  [
            const Text('Account',style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
            Text('INR ${tot}',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold))
          ]),
        )
    ]
    ),
    
  );
}