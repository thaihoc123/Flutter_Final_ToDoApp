import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  TextEditingController email = new TextEditingController();
  TextEditingController otp = new TextEditingController();
  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Column(
                  children: [
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.mail,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              myauth.setConfig(
                                  // appEmail: "contact@hdevcoder.com",
                                  appEmail: 'thaihoc2le2@gmail.com',
                                  appName: "Email OTP",
                                  userEmail: email.text,
                                  otpLength: 4,
                                  otpType: OTPType.digitsOnly);
                              if (myauth.sendOTP() == false) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("OTP has been sent"),
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Oops, OTP send failed"),
                                ));
                              }
                            },
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Colors.teal,
                            )),
                        hintText: "Email Address",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: otp,
                          decoration:
                              const InputDecoration(hintText: "Enter OTP")),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (await myauth.verifyOTP(otp: otp.text) == true) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("OTP is verified"),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid OTP"),
                            ));
                          }
                        },
                        child: const Text("Verify")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
