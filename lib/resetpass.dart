import 'package:flutter/material.dart';

class ResetPassView extends StatefulWidget {
  const ResetPassView({super.key});

  @override
  State<ResetPassView> createState() => _ResetPassViewState();
}

class _ResetPassViewState extends State<ResetPassView> {
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
    return Scaffold(
        appBar: AppBar(title: const Text('Forgot Password'),backgroundColor: Colors.purple[700],),
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
              decoration: const InputDecoration(hintText: 'Enter your password'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
              },
              child: const Text('Continue'),
            ),
          ]),
        ),
      );
  }
}