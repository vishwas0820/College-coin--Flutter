import 'package:collegecoin/bloc/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collegecoin/bloc/auth_bloc.dart';
import 'package:collegecoin/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Column(children: [
          const Text("We've sent you an email verification. Please open it to verify your account"),
          const Text('If you have not recieved a verification email yet, press the button below'),
          TextButton(onPressed: () async {
            /*context.read<AuthBloc>().add(const AuthEventSendEmailVerification());*/
            await AuthService.firebase().sendEmailVerification();
          },
          child: const Text('Send email verification'),),
          TextButton(onPressed: () async{
            /*context.read<AuthBloc>().add(const AuthEventLogOut());*/
            await AuthService.firebase().logOut();
            Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
          }, 
          child: const Text('Restart')),
        ]),
    );
  }
}