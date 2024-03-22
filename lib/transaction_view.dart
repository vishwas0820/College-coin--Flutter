import 'package:collegecoin/cloud/transaccloud.dart';
import 'package:collegecoin/resources/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'cloud/transac_cloud_storage.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  
  final traService=TransacCloudStorage();
  String? uid=FirebaseAuth.instance.currentUser?.uid;
  Iterable<TransacCloud>? ordIds;
  late Color c;
  late String sign;
  List<double> price=[];
  late Iterable<TransacCloud> gpdata;
  List<double> gdata=[];
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

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
    //final LineChartData data=mainData();
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions'),backgroundColor: Colors.purple[700],),
      body: Column(
        children: [
          SizedBox(height: 20,),
          
          SizedBox(
            child: FutureBuilder(
              future: traService.linedata(uid,context),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  gpdata=snapshot.data!;
                  print(gpdata);
                  for(final ele in gpdata){
                      gdata.add(double.parse(ele.amt));
                  }
                  print(gdata);
                  
                  return SizedBox(
            width: 350,
            child: AspectRatio(aspectRatio: 1.70,
            child: LineChart(mainData(gdata)),
            ),
          );
                  
                } else{
                  return Text("Loading");
                }
                
              },
            ),
          ),
          /*SizedBox(
            width: 350,
            child: AspectRatio(aspectRatio: 1.70,
            child: LineChart(mainData()),
            ),
          ),*/
          SizedBox(height: 30,),
          Expanded(
            child: FutureBuilder(
              future: traService.getTransac(uid, context),
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
                      /*price.add(double.parse(ord?.amt as String));*/
                      return Card(
                        child: ListTile(
                        title: Text(ord!.type),
                        subtitle: Text(ord.desc),
                        trailing: Text('$sign${ord.amt}',style: TextStyle(color: c,fontSize: 16,fontWeight: FontWeight.bold),),
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
          ),
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
        ),
    );
  }
  /* Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '100';
        break;
      case 3:
        text = '300';
        break;
      case 5:
        text = '500';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }*/

  LineChartData mainData(List<double> gdata) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        /*bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            
            reservedSize: 42,
          ),
        ),*/
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 1000,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, gdata[0]),
            FlSpot(2, gdata[1]),
            FlSpot(4, gdata[2]),
            FlSpot(6, gdata[3]),
            FlSpot(8, gdata[4]),
            FlSpot(11, gdata[5]),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}