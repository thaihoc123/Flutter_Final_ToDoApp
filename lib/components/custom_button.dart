import 'package:flutter/material.dart';
import '../resources/app_color.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 100).copyWith(top: 30),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(color: AppColor.green),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                offset: Offset(3, 3),
                color: AppColor.clshadow,
                blurRadius: 6,
              )
            ]),
        child: Align(
          child: Text(
            text,
            style: const TextStyle(
                color: AppColor.black,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        ),
      ),
    );
  }
}
