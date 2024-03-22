import 'package:collegecoin/addtrans.dart';
import 'package:collegecoin/bloc/auth_service.dart';
import 'package:collegecoin/bloc/firebase_auth_provider.dart';
import 'package:collegecoin/changelimit.dart';
import 'package:collegecoin/changelimitwallet.dart';
import 'package:collegecoin/homepage.dart';
import 'package:collegecoin/login_view.dart';
import 'package:collegecoin/profile.dart';
import 'package:collegecoin/resetpass.dart';
import 'package:collegecoin/signup_view.dart';
import 'package:collegecoin/start_view.dart';
import 'package:collegecoin/transaction_view.dart';
import 'package:collegecoin/updateamt.dart';
import 'package:collegecoin/verify_email_view.dart';
import 'package:collegecoin/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'addwallet.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';
import 'budgetview.dart';
import 'forgot_password_view.dart';
import 'loading/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
        ),
      routes:{
        '/start/':(context) => const HomePage(),
        '/login/':(context) => const LoginView(),
        '/register/':(context) => const SignupView(),
        '/home/':((context) => const MyHomePage()),
        '/trans/':((context) => const TransactionView()),
        '/profile/':(context) => const ProfileScreen(),
        '/wallet/':(context) => const WalletView(),
        '/addwallet/':(context) => const AddWallet(),
        '/addtrans/':(context) => const AddTransac(),
        '/changelim/':(context) => const ChangeLimitView(),
        '/budget/':(context) => const BudgetView(),
        '/verify/':(context) => const VerifyEmailView(),
        '/changewallet/':(context) => const ChangeWalletView(),
        '/addamt/':(context) => const AddAmtView(),
        '/forgotpass/':(context) => const ForgotPasswordView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context,snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.done:
            final user= AuthService.firebase().currentUser;
            if(user!=null){
              if(user.isEmailverified) {
                return const MyHomePage();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const StartView();
            }
          default:
            return const SizedBox(height: 50,width: 50,child: CircularProgressIndicator(),);
        }
      }
    );
    /*context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener:(context, state) {
      if(state.isLoading) {
        LoadingScreen().show(context: context, text: state.loadingText ?? 'Please wait a moment');

      } else {
        LoadingScreen().hide();
      }
    },
      builder: (context, state) {
      if(state is AuthStateLoggedIn) {
        return const MyHomePage();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if(state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
      } else if(state is AuthStateRegistering){
        return const SignupView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });*/
  }
}
