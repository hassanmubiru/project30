import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project30/models/play.dart';
import 'package:project30/provider/authentication_provider.dart';
import 'package:project30/utlis/widgets.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../utlis/validators.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String? _username, _password;
  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    
    final  usernameField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      decoration: buildInputDecoration('Confirm Email', Icons.email),
      onSaved:(value) => _username = value ,
    );

    final  passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: buildInputDecoration('Confirm Password', Icons.lock),
      validator: (value) => value!.isEmpty? "Please enter password" : null,
      onSaved:(value) => _password = value ,
    );
    var loading = const Row(
      children: <Widget>[
        CircularProgressIndicator(),
        Text('Authenticating .... Please wait')
 

    ],);
    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ElevatedButton(
          
          child: const Text("Forgot password",
          style: TextStyle(fontWeight: FontWeight.w300),
          ),
          onPressed:(){

          },
          
          
        ),
         ElevatedButton(
          
          child: const Text("Sign up",
          style: TextStyle(fontWeight: FontWeight.w300),
          ),
          onPressed:(){

          }
          
        ),
      ],
    );

    var doLogin = (){
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();

        final Future<Map<String,dynamic>>successfullMessage = 
        auth.login(_username!,_password!);

        successfullMessage.then((response){
          if(response['status']){
            User user = response['user'];
            Provider.of<UserProvider>(context,listen:false).setUser(user);
            Navigator.pushReplacementNamed(context, '');
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to Login')));
          }
        }
        
        );
      } else{
        print("form invalid");
      }
    };
    return  SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              label('Email'),
              const SizedBox(height: 5,),
              usernameField,
              const SizedBox(height: 5,),
              label('Password'),
              passwordField,
              const SizedBox(height:20),
              auth.loggedInStatus == Status.Authenticating ? loading : longButtons("Login", doLogin),
              const SizedBox()

            ],
          ) ,
        ),
      ),
    );
  }
}