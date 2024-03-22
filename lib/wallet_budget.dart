import 'package:collegecoin/cloud/walletcloud.dart';
import 'package:flutter/material.dart';

class WalletBudgetCard extends StatelessWidget {
  final WalletCloud wal;

  const WalletBudgetCard({Key? key,required this.wal}): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(wal.walname,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            const SizedBox(height: 20,),
            const Text("Remaining",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            const SizedBox(height: 20,),
            Text("INR ${wal.amt}",style: const TextStyle(fontSize: 36,fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
                width: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    minHeight: 20,
                    backgroundColor: Colors.red,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal,),
                    value: calcgreen(wal),
                  ),
                ),
              ),
            Center(
              child: 
                Text(showText(wal),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
            ),
          ],
        ),
      ),
    );
  }

  double calcgreen(WalletCloud w){
    int val=int.parse(w.amt);
    return val/5000;
  }

  String showText(WalletCloud w){
    int val=int.parse(w.amt);
    int lim=int.parse(w.limit);
    if(val<lim){
                    return ("You have exceeded the limit!");
    } else if(val>lim){
                    return ("You have not exceeded the limit");
    } else{
              return ("You have reached the limit!");
    }
  }
}