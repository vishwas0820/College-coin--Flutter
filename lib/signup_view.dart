import 'package:collegecoin/bloc/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_exceptions.dart';
import 'bloc/auth_state.dart';
import 'dialogs/error_dialog.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
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
      listener: (context, state) async {
        if(state is AuthStateRegistering) {
          if(state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException){
            await showErrorDialog(context, 'Email Already in use');
          } else if (state.exception is GenericAuthException){
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException){
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },*/
      return Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              decoration: const InputDecoration(hintText: 'Enter your password'),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        /*context.read<AuthBloc>().add(AuthEventRegister(email, password));*/
                        try{
                          await AuthService.firebase().createUser(email: email, password: password);
                          AuthService.firebase().sendEmailVerification();
                          Navigator.of(context).pushNamed('/verify/');
                        } on FirebaseAuthException catch(e){
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
                      child: const Text('Register',style: TextStyle(color: Colors.black),),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        /*context.read<AuthBloc>().add(const AuthEventLogOut());*/
                        Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                      },
                      child: const Text('Already registered? Login here',style: TextStyle(color: Colors.black),))
                ],
              ),
            ),
          ]),
        ),
      );
    
  }
}
