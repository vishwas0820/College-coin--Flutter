import 'package:collegecoin/bloc/auth_service.dart';
import 'package:collegecoin/main.dart';
import 'package:collegecoin/profilemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'menuaction.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  void _onItemTapped(int index) {
    /*setState(() {
      _selectedIndex = index;
    });*/
    if (index == 0) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home/', (route) => false);
    } else if (index == 1) {
      Navigator.of(context).pushNamedAndRemoveUntil('/trans/', (route) => false,
          arguments: index);
    } else if (index == 3) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/profile/', (route) => false,
          arguments: index);
    } else if (index == 2) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/budget/', (route) => false,
          arguments: index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex =
        ModalRoute.of(context)?.settings.arguments as int;

    final String name = getName(user);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.purple[700],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/profile.png')),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.purple),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              Text(user?.email as String,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.normal)),
              const SizedBox(height: 20),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Change Password",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {
                    Navigator.of(context).pushNamed('/forgotpass/');
                  }),
              ProfileMenuWidget(
                  title: "Account",
                  icon: LineAwesomeIcons.wallet,
                  onPress: () {
                    Navigator.of(context).pushNamed('/wallet/');
                  }),
              ProfileMenuWidget(
                  title: "Change Limit",
                  icon: LineAwesomeIcons.money_bill,
                  onPress: () {
                    Navigator.of(context).pushNamed('/changewallet/');
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () async {
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    /*context.read<AuthBloc>().add(const AuthEventLogOut(),);*/
                    await AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/start/', (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
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
            icon: Icon(Icons.wallet_sharp),
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

  String getName(User? user) {
    String s;
    if (user?.email == "vishwasgc20@gmail.com") {
      s = "Vishwas";
    } else if (user?.email == "vinayak.cs21@bmsce.ac.in") {
      s = "Vinayak";
    } else if (user?.email == "vishwas.cs21@bmsce.ac.in") {
      s = "Vishwas";
    } else {
      s = "Vinayak";
    }
    return s;
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log Out"))
          ],
        );
      }).then((value) => value ?? false);
}
