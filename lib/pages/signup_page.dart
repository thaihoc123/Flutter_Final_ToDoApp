import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_11_5/components/custom_app_bar.dart';
import 'package:todo_app_11_5/components/custom_button.dart';
import 'package:todo_app_11_5/components/custom_text_field.dart';
import 'package:todo_app_11_5/models/account_model.dart';
import 'package:todo_app_11_5/pages/home_page.dart';
import 'package:todo_app_11_5/resources/app_color.dart';
import 'package:todo_app_11_5/services/shared_prefs.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool passwordMatchError = false;
  bool isPassword = true;
  IconData? iconPass = Icons.visibility;
  final SharedPrefs _prefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
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
          body: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Registation Form',
                          style: TextStyle(
                              color: AppColor.blue,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        CustomTextField(
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
                          onChanged: (value) {
                            setState(() {
                              passwordMatchError = passwordController.text !=
                                  rePasswordController.text;
                            });
                          },
                        ),
                        CustomTextField(
                          iconData: Icons.lock,
                          controller: rePasswordController,
                          hintText: 'Repeat password',
                          isPassword: isPassword,
                          onChanged: (value) {
                            setState(() {
                              passwordMatchError = passwordController.text !=
                                  rePasswordController.text;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                            visible: passwordMatchError,
                            child: const Text(
                              'Passwords is not match',
                              style: TextStyle(
                                  color: AppColor.red,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 300,
                left: 40,
                right: 40,
                child: CustomButton(
                  text: 'Sign up',
                  onTap: () {
                    String username = usernameController.text.trim();
                    String password = passwordController.text.trim();
                    String repassword = rePasswordController.text.trim();
                    String? notification;
                    if (username == '' && password == '') {
                      notification = 'Please insert username and password';
                    } else if (username == '') {
                      notification = 'Please insert username';
                    } else if (password == '') {
                      notification = 'Please insert password';
                    } else if (password != repassword) {
                      notification = 'Password is not match!';
                    } else if (username.length < 6 ||
                        username.length > 35 ||
                        password.length < 6 ||
                        password.length > 35) {
                      notification =
                          'Username and password have be from 6 to 35 characters';
                    } else {
                      accountList.add(
                          AccountModel(username: username, password: password));
                      _prefs.addSignup(accountList);
                      print(accountList1);
                      accountList1.addAll(accountList);
                      print(accountList1);
                      _prefs.addAccount(accountList1);
                      notification = 'Sign up success!';
                      Route route =
                          MaterialPageRoute(builder: (context) => HomePage());
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
              )
            ],
          )),
    );
  }
}
