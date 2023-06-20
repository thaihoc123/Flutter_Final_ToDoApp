import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_11_5/pages/reset_pass_page.dart';

import '../resources/app_color.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: ('0'),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.myauth}) : super(key: key);
  final EmailOTP myauth;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  String otpController = "1234";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Icon(Icons.dialpad_rounded, size: 50),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Enter Mary's PIN",
            style: TextStyle(fontSize: 40),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Otp(
                otpController: otp1Controller,
              ),
              Otp(
                otpController: otp2Controller,
              ),
              Otp(
                otpController: otp3Controller,
              ),
              Otp(
                otpController: otp4Controller,
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () async {
              if (await widget.myauth.verifyOTP(
                      otp: otp1Controller.text +
                          otp2Controller.text +
                          otp3Controller.text +
                          otp4Controller.text) ==
                  true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: AppColor.grey,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  content: Text("OTP is verified"),
                ));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResetPassPage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: AppColor.grey,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  content: Text("Invalid OTP"),
                ));
              }
            },
            child: const Text(
              "Confirm",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
