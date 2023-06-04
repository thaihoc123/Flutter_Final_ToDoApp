import 'package:flutter/material.dart';
import 'package:todo_app_11_5/resources/app_color.dart';

class CustomSearchBox extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const CustomSearchBox({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColor.grey,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: AppColor.grey),
          prefixIcon: Icon(
            Icons.search,
            color: AppColor.brown,
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 40),
        ),
      ),
    );
  }
}
