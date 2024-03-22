import 'package:collegecoin/bloc/auth_service.dart';
import 'package:collegecoin/homepage.dart';
import 'package:collegecoin/resetpass.dart';
import 'package:collegecoin/signup_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_exceptions.dart';
import 'bloc/auth_state.dart';
import 'dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async{
        if(state is AuthStateLoggedOut) {
          if(state.exception is UserNotFoundAuthException){
                          await showErrorDialog(context,'User not found');
          } else if(state.exception is WrongPasswordAuthException){
                          await showErrorDialog(context, 'Wrong Credentials');
          } else if(state.exception is GenericAuthException){
                          await showErrorDialog(context, 'Authentication error');
          }
          }
      },*/
      return Scaffold(
        appBar: AppBar(title: const Text('Login'),backgroundColor: Colors.purple[700],),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter your email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter your password'),
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  /*context.read<AuthBloc>().add(AuthEventLogIn(email, password));*/
                  try {
                    await AuthService.firebase().logIn(email: email, password: password);
                    final user =AuthService.firebase().currentUser;
                    if(user?.isEmailverified ?? false){
                      Navigator.of(context).pushNamedAndRemoveUntil('/home/', (route) => false);
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil('/verify/', (route) => false);
                    }
                  } on FirebaseAuthException catch(e) {
                    await showErrorDialog(context, 'Error: ${e.code}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.purple[700],
                  backgroundColor: Colors.blueGrey[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Login'),
              ),
            ),
            TextButton(
                onPressed: () {
                  /*context.read<AuthBloc>().add(const AuthEventForgotPassword());*/
                  Navigator.of(context).pushNamed('/forgotpass/');
                },
                child: const Text('I forgot my password',style: TextStyle(color: Colors.black),),),
            TextButton(
                onPressed: () {
                  /*context.read<AuthBloc>().add(const AuthEventShouldRegister());*/
                  Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
                },
                child: const Text('Not registered yet? Sign up',style: TextStyle(color: Colors.black),))
          ]),
        ),
      );
    
  }
}
