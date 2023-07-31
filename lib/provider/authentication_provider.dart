import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/play.dart';
import '../repository/user_preferences.dart';
import '../utlis/constants.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredStatus => _registeredStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'user': {
        'email': email,
        'password': password,
      }
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(AppUrl.login),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'successfull', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String passwordConfirmation) async {
    final Map<String, dynamic> registrationData = {
      'user': {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }
    };

    _registeredStatus = Status.Registering;
    notifyListeners();

    try {
      Response response = await post(
        Uri.parse(AppUrl.register),
        body: json.encode(registrationData),
        headers: {"content-Type": "application/json"},
      );

      return await onValue(response);
    } catch (error) {
      return onError(error);
    }
  }

  static Future<Map<String, dynamic>> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      var userData = responseData['data'];
      User authUser = User.fromJson(userData);
      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully Registered',
        'data': authUser
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration Failed',
        'data': responseData
      };
    }
    return result;
  }

  static onError(error) {
    print("the error is $error detail");
    return {'status': false, 'message': 'Unsuccessfull Request', 'data': error};
  }
}