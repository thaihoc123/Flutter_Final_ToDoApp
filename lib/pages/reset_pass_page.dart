import 'package:flutter/material.dart';
import 'package:todo_app_11_5/components/custom_app_bar.dart';
import 'package:todo_app_11_5/components/custom_text_field.dart';
import 'package:todo_app_11_5/models/account_model.dart';
import 'package:todo_app_11_5/pages/home_page.dart';
import 'package:todo_app_11_5/pages/login_page.dart';
import '../services/shared_prefs.dart';
import '../components/custom_button.dart';
import '../resources/app_color.dart';

class ResetPassPage extends StatefulWidget {
  const ResetPassPage({super.key});

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController ResetPassPageController = TextEditingController();
  bool isPassword = true;
  IconData? iconPass = Icons.visibility;
  final SharedPrefs _prefs = SharedPrefs();
  AccountModel account = AccountModel();
  bool passwordMatchError = false;

  @override
  void initState() {
    for (var acc in accountList) {
      setState(() {
        account = acc;
      });
    }
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
            showAvatar: false,
            leftPressed: () {
              Navigator.pop(context);
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
                      controller: newPasswordController,
                      hintText: 'New Password',
                      iconPass: iconPass,
                      onPass: _showPassword,
                      isPassword: isPassword,
                      onChanged: (value) {
                        setState(() {
                          passwordMatchError = newPasswordController.text !=
                              ResetPassPageController.text;
                        });
                      },
                    ),
                    CustomTextField(
                      iconData: Icons.lock,
                      controller: ResetPassPageController,
                      hintText: 'Repeat Password',
                      isPassword: isPassword,
                      onChanged: (value) {
                        setState(() {
                          passwordMatchError = newPasswordController.text !=
                              ResetPassPageController.text;
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
                top: 300,
                left: 40,
                right: 40,
                child: CustomButton(
                  text: 'Submit',
                  onTap: () {
                    String username = usernameController.text.trim();
                    String password = passwordController.text.trim();
                    String newPassword = newPasswordController.text.trim();
                    String ResetPassPage = ResetPassPageController.text.trim();
                    String notification = 'Changed password success!';
                    print(account.username);
                    print(account.password);
                    if (newPassword == '' || ResetPassPage == '') {
                      notification = 'Please insert information!';
                    } else if (newPassword == '') {
                      notification = 'Please insert new password';
                    } else if (newPassword != ResetPassPage) {
                      notification = 'Confirm Password is not match!';
                    } else if (newPassword.length < 6 ||
                        newPassword.length > 35) {
                      notification = 'Password have be from 6 to 35 characters';
                    } else
                      setState(() {
                        accountList.clear();
                        accountList.add(AccountModel(
                            username: username, password: newPassword));
                      });
                    _prefs.addSignup(accountList);
                    accountList1.clear();
                    _prefs.addAccount(accountList1);
                    notification = 'Reset password success!';
                    Route route = MaterialPageRoute(
                        builder: (context) => LoginPage(
                              user: usernameController,
                            ));
                    Navigator.push(context, route);

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
