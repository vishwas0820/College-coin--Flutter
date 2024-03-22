import 'package:collegecoin/profile.dart';
import 'package:collegecoin/sector.dart';
import 'package:collegecoin/transaction_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'cloud/transac_cloud_storage.dart';
import 'cloud/transaccloud.dart';
import 'cloud/wallet_cloud_storage.dart';
import 'cloud/walletcloud.dart';
import 'menuaction.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late Color c;
  late String sign;
  final traService=TransacCloudStorage();
  final walService=WalletCloudStorage();
  String? uid=FirebaseAuth.instance.currentUser?.uid;
  late Iterable<WalletCloud> val;
  late int walamt=0;
  Iterable<TransacCloud>? ordIds;
  late List<Sector> sectors;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          backgroundColor: Colors.purple[700],
          actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(const AuthEventLogOut(),);
                }
                break;
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text('Logout'))
            ];
          })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: traService.getGraphData(uid),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        sectors=snapshot.data!;
                        return SizedBox(
                    width: 400,
                    height: 200,
                    child: PieChart(PieChartData(
                      sections: _chartSections(sectors),
                      centerSpaceRadius: 48.0
                    )),
                  );
                      } else{
                        return const Center(child: Text("You haven't added any transactions"));
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  const Text('Account Balance',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  SizedBox(
                    child: FutureBuilder(
                      future: walService.getWallets(uid, context),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          val=snapshot.data!;
                          for(final v1 in val){
                            walamt=walamt+int.parse(v1.amt);
                          }
                          return Text("Rs. ${walamt}",style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),);
                        } else{
                          return const Text("Loading");
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30,),
                  const Text('Transactions',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 500,
                    width: 400,
                    child: FutureBuilder(
              future: traService.getTransacHome(uid, context),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  ordIds=snapshot.data;
                  return ListView.builder(
                    itemCount: ordIds?.length,
                    itemBuilder: ((context, index) {
                      final ord=ordIds?.elementAt(index);
                      if(ord?.exin=='Expense'){
                        c=Colors.red;
                        sign='-';
                      } else {
                        c=Colors.green;
                        sign='+';
                      }
                      return SizedBox(
                        height: 80,
                        child: Card(
                          child: ListTile(
                          title: Text(ord!.type),
                          subtitle: Text(ord.desc),
                          trailing: Text('$sign${ord.amt}',style: TextStyle(color: c,fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      );
                  })
                  );
                }
                else{
                  return const Center(child: Text("You haven't added any transactions"));
                }
              },
            ),
                  )
                ],
              ),
            
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.of(context).pushNamed('/addtrans/');},
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
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
        ),
      );
  }
  List<PieChartSectionData> _chartSections(List<Sector> sectors) {
    final List<PieChartSectionData> list = [];
    for (var sector in sectors) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        value: sector.value,
        radius: radius,
        title: sector.title,
        color: sector.col
      );
      list.add(data);
    }
    print("Pie Chart ${list}");
    return list;
  }
}