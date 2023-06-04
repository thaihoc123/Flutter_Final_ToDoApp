import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app_11_5/models/account_model.dart';
import 'package:todo_app_11_5/pages/home_page.dart';
import 'package:todo_app_11_5/pages/login_page.dart';
import 'package:todo_app_11_5/pages/signup_page.dart';
import 'package:todo_app_11_5/services/shared_prefs.dart';

class SpLashPage extends StatefulWidget {
  const SpLashPage({super.key});

  @override
  State<SpLashPage> createState() => _SpLashPageState();
}

class _SpLashPageState extends State<SpLashPage> {
  final SharedPrefs _prefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    _getSignup();
    _getAccount();
    Timer(const Duration(seconds: 3), () {
      if (accountList.isEmpty) {
        Route route = MaterialPageRoute(builder: (context) => SignUpPage());
        Navigator.push(context, route);
      } else {
        for (var account in accountList) {
          print(account.username);
          print(account.password);
        }
        if (accountList1.isEmpty) {
          Route route = MaterialPageRoute(builder: (context) => LoginPage());
          Navigator.push(context, route);
        } else {
          Route route = MaterialPageRoute(builder: (context) => HomePage());
          Navigator.push(context, route);
        }
      }
    });
  }

  _getAccount() {
    _prefs.getAccount().then((value) => accountList1 = value ?? []);
  }

  _getSignup() {
    _prefs.getSignup().then((value) => accountList = value ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/univers.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/images/hoclogo.png',
                width: 160.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
