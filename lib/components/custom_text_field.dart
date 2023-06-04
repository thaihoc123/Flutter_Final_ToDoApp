import 'package:flutter/material.dart';
import 'package:todo_app_11_5/resources/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool? isPassword;
  final IconData? iconData;
  final IconData? iconPass;
  final VoidCallback? onPass;
  final bool? readOnly;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.isPassword,
    this.iconData,
    this.iconPass,
    this.onPass,
    this.readOnly,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: AppColor.green),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 3),
              color: AppColor.clshadow,
              blurRadius: 6,
            )
          ]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: readOnly ?? false,
              obscureText: isPassword ?? false,
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                  prefixIcon: Icon(iconData, color: AppColor.green),
                  border: InputBorder.none,
                  hintText: hintText,
                  prefixIconConstraints: const BoxConstraints(minWidth: 40),
                  errorText: errorText),
            ),
          ),
          GestureDetector(
            onTap: onPass,
            child: Icon(
              iconPass,
              color: AppColor.green,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
