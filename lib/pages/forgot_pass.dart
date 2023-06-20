import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_11_5/components/custom_app_bar.dart';
import 'package:todo_app_11_5/models/account_model.dart';
import 'package:todo_app_11_5/pages/otp_screen.dart';
import 'package:todo_app_11_5/pages/reset_pass_page.dart';
import '../resources/app_color.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  EmailOTP myauth = EmailOTP();
  AccountModel account = AccountModel();
  bool isOTP = false;
  @override
  void initState() {
    for (var acc in accountList) {
      account = acc;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leftPressed: () {
          Navigator.pop(context);
        },
        title: '',
        showAvatar: false,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                'Forgot Password',
                style: TextStyle(
                    color: AppColor.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (emailController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Please inset your email!"),
                              ));
                            } else if (emailController.text.trim() !=
                                account.username) {
                              print(account.username);
                              print(emailController.text);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Email have not been signed up yet!?"),
                              ));
                            } else
                              () async {
                                myauth.setConfig(
                                    appEmail: "contact@hdevcoder.com",
                                    appName: "Email OTP",
                                    userEmail: emailController.text,
                                    otpLength: 4,
                                    otpType: OTPType.digitsOnly);
                                if (await myauth.sendOTP()) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("OTP has been sent"),
                                  ));
                                  setState(() {
                                    isOTP = true;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpScreen(
                                                myauth: myauth,
                                              )));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Oops, OTP send failed"),
                                  ));
                                }
                              }();
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            color: AppColor.teal,
                          )),
                      hintText: "Email Address",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
