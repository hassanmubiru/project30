// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:project30/provider/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../models/play.dart';
import '../provider/user_provider.dart';
import '../utlis/validators.dart';
import '../utlis/widgets.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  String? _username, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    final usernameField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      decoration: buildInputDecoration('Enter Email', Icons.email),
      onSaved: (value) => _username = value,
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: buildInputDecoration('Enter Password', Icons.lock),
      validator: (value) => value!.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: buildInputDecoration('Confirm Password', Icons.lock),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter password";
        } else if (value != _password) {
          return "Passwords do not match";
        }
        return null;
      },
      onSaved: (value) => _confirmPassword = value,
    );

    var loading = const Row(
      children: <Widget>[
        CircularProgressIndicator(),
        Text('Authenticating .... Please wait'),
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();

        auth.register(_username!, _password!, _confirmPassword!).then((response) {
          if (response['status']) {
            User user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '');
          } else { 
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Failed to Register')));
          }
        });
      } else {
        print("Form is invalid");
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 15),
                label("Email"),
                const SizedBox(height: 5),
                usernameField,
                const SizedBox(height: 5),
                label("Password"),
                passwordField,
                const SizedBox(height: 20),
                label("Confirm Password"),
                confirmPasswordField,
                const SizedBox(height: 20),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Register", doRegister),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
