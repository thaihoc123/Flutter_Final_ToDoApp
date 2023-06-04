import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_11_5/components/custom_app_bar.dart';
import 'package:todo_app_11_5/components/custom_text_field.dart';
import 'package:todo_app_11_5/models/account_model.dart';
import 'package:todo_app_11_5/pages/home_page.dart';
import '../services/shared_prefs.dart';
import '../components/custom_button.dart';
import '../resources/app_color.dart';

class LoginPage extends StatefulWidget {
  final TextEditingController? user;
  const LoginPage({super.key, this.user});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPassword = true;
  IconData? iconPass = Icons.visibility;
  final SharedPrefs _prefs = SharedPrefs();
  File? _image;

  @override
  void initState() {
    if (widget.user != null) {
      setState(() {
        usernameController.text = widget.user!.text;
      });
    }
    super.initState();
    loadSavedImage();
  }

  Future<void> loadSavedImage() async {
    final imagePath = await _prefs.getImagePath();

    if (imagePath != null && imagePath.isNotEmpty) {
      final imageFile = File(imagePath);
      setState(() {
        _image = imageFile;
      });
    }
  }

  void _showPassword() {
    setState(() {
      isPassword = !isPassword;
      if (!isPassword) {
        iconPass = Icons.visibility_off;
      } else {
        iconPass = Icons.visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Future.value(false);
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          showAvatar: false,
          imageFile: _image,
          leftPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text('Do you want to exit?'),
                  title: const Text('🌗 Exit!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                        Navigator.pop(context);
                      },
                      child: const Text('Yes 😭'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No 🥰'),
                    ),
                  ],
                );
              },
            );
          },
          title: '',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              const Text(
                'Login Form',
                style: TextStyle(
                    color: AppColor.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              CustomTextField(
                onChanged: (value) {},
                readOnly: widget.user != null,
                iconData: Icons.man_4,
                controller: usernameController,
                hintText: 'Username',
              ),
              CustomTextField(
                iconData: Icons.lock,
                controller: passwordController,
                hintText: 'Password',
                isPassword: isPassword,
                iconPass: iconPass,
                onPass: _showPassword,
              ),
              CustomButton(
                text: 'Login',
                onTap: () {
                  String username = usernameController.text.trim();
                  String password = passwordController.text.trim();
                  String notification = 'Username or password is wrong';
                  if (username == '' && password == '') {
                    notification = 'Please insert username and password';
                  } else if (password == '') {
                    notification = 'Please insert password';
                  } else if (username == '') {
                    notification = 'Please insert username';
                  }
                  for (var account in accountList) {
                    if (username == account.username &&
                        password == account.password) {
                      accountList1.add(account);
                      _prefs.addAccount(accountList1);
                      notification = 'Login Success';
                      Route route =
                          MaterialPageRoute(builder: (context) => HomePage());
                      Navigator.push(context, route);
                    }
                  }
                  final snackBar = SnackBar(
                    content: Text(notification),
                    backgroundColor: AppColor.grey,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
