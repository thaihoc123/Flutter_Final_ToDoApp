import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_app_11_5/components/custom_app_bar.dart';
import 'package:todo_app_11_5/components/custom_text_field.dart';
import 'package:todo_app_11_5/models/account_model.dart';
import 'package:todo_app_11_5/pages/home_page.dart';
import 'package:todo_app_11_5/pages/login_page.dart';
import '../services/shared_prefs.dart';
import '../components/custom_button.dart';
import '../resources/app_color.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController ChangePasswordController = TextEditingController();
  bool isPassword = true;
  IconData? iconPass = Icons.visibility;
  final SharedPrefs _prefs = SharedPrefs();
  AccountModel account = AccountModel();
  bool passwordMatchError = false;
  File? _image;

  @override
  void initState() {
    for (var acc in accountList1) {
      setState(() {
        account = acc;
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
        Route route = PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
        Navigator.push(context, route);
        return true;
      },
      child: Scaffold(
          appBar: CustomAppBar(
            imageFile: _image,
            leftPressed: () {
              Route route = PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
              );
              Navigator.push(context, route);
            },
            title: '',
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                          color: AppColor.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    CustomTextField(
                      readOnly: true,
                      iconData: Icons.man_4,
                      controller: usernameController =
                          TextEditingController(text: account.username),
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
                    CustomTextField(
                      iconData: Icons.lock,
                      controller: newPasswordController,
                      hintText: 'New Password',
                      isPassword: isPassword,
                      onChanged: (value) {
                        setState(() {
                          passwordMatchError = newPasswordController.text !=
                              ChangePasswordController.text;
                        });
                      },
                    ),
                    CustomTextField(
                      iconData: Icons.lock,
                      controller: ChangePasswordController,
                      hintText: 'Repeat Password',
                      isPassword: isPassword,
                      onChanged: (value) {
                        setState(() {
                          passwordMatchError = newPasswordController.text !=
                              ChangePasswordController.text;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                        visible: passwordMatchError,
                        child: const Text(
                          'Passwords is not match',
                          style: TextStyle(
                              color: AppColor.red, fontWeight: FontWeight.bold),
                        )),
                  ]),
                ),
              ),
              Positioned(
                top: 350,
                left: 40,
                right: 40,
                child: CustomButton(
                  text: 'Submit',
                  onTap: () {
                    String username = usernameController.text.trim();
                    String password = passwordController.text.trim();
                    String newPassword = newPasswordController.text.trim();
                    String ChangePassword = ChangePasswordController.text.trim();
                    String notification = 'Changed password success!';
                    print(account.username);
                    print(account.password);
                    if (password == '' ||
                        newPassword == '' ||
                        ChangePassword == '') {
                      notification = 'Please insert information!';
                    } else if (password == '') {
                      notification = 'Please insert password';
                    } else if (newPassword == '') {
                      notification = 'Please insert new password';
                    } else if (newPassword != ChangePassword) {
                      notification = 'Confirm Password is not match!';
                    } else if (password != account.password) {
                      notification = 'Password is wrong!';
                    } else if (password == newPassword) {
                      notification = 'Password and newpassword is the same!';
                    } else if (newPassword.length < 6 ||
                        newPassword.length > 35) {
                      notification = 'Password have be from 6 to 35 characters';
                    } else if (username == account.username &&
                        password == account.password) {
                      setState(() {
                        accountList.clear();
                        accountList.add(AccountModel(
                            username: username, password: newPassword));
                      });
                      _prefs.addSignup(accountList);
                      accountList1.clear();
                      _prefs.addAccount(accountList1);
                      notification = 'Change password success!';
                      Route route = MaterialPageRoute(
                          builder: (context) => LoginPage(
                                user: usernameController,
                              ));
                      Navigator.push(context, route);
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
              ),
            ],
          )),
    );
  }
}
