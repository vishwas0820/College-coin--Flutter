import 'package:collegecoin/cloud/wallet_cloud_storage.dart';
import 'package:collegecoin/cloud/walletcloud.dart';
import 'package:collegecoin/resources/app_colors.dart';
import 'package:collegecoin/wallet_budget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  final wal=WalletCloudStorage();
  String? uid=FirebaseAuth.instance.currentUser?.uid;
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  late int limval=0;
  late Iterable<WalletCloud> val;
  late int walamt=0;
  late double greenval=0;
  void _onItemTapped(int index) {
    /*setState(() {
      _selectedIndex = index;
    });*/
    if(index==0){
      Navigator.of(context).pushNamedAndRemoveUntil('/home/', (route) => false);
    } else if(index==1){
      Navigator.of(context).pushNamedAndRemoveUntil('/trans/',(route) => false,arguments: index);
    } else if(index==3){
      Navigator.of(context).pushNamedAndRemoveUntil('/profile/',(route) => false,arguments: index );
    } else if(index==2){
      Navigator.of(context).pushNamedAndRemoveUntil('/budget/', (route) => false,arguments: index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex=ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(title: const Text("Budget"),backgroundColor: Colors.purple[700],),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Expanded(
            child: FutureBuilder(
              future: wal.getWallets(uid, context),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  val=snapshot.data!;
                  for(final v1 in val){
                    walamt=int.parse(v1.amt);
                  }
                  return ListView.builder(
                  itemCount: val.length,
                  itemBuilder: (context,index){
                    return WalletBudgetCard(wal: val.elementAt(index));
                  },
                );
                } else {
                  return Text("Loading...");
                }
                
              },
              )
            ),
          /*const Center(
            
            child: SizedBox(
              width: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  minHeight: 20,
                  backgroundColor: Colors.red,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal,),
                  value: 0.65,
                ),
              ),
            ),
          ),*/
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[700],
        onTap: _onItemTapped,
        )
    );
    
  }
}