import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_app_11_5/resources/app_color.dart';
import 'dart:math' as m;

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final VoidCallback? leftPressed;
  final VoidCallback? onAvatar;
  final String? title;
  final File? imageFile;
  final IconData? icon;
  final bool? showAvatar;
  const CustomAppBar(
      {super.key,
      this.leftPressed,
      this.title,
      this.onAvatar,
      this.imageFile,
      this.icon, this.showAvatar});

  @override
  Widget build(BuildContext context) {
    double size = 30;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10)
          .copyWith(top: MediaQuery.of(context).padding.top + 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: leftPressed,
            child: Transform.rotate(
              angle: m.pi / 4,
              child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: icon == null ? AppColor.white : AppColor.tran,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: icon != null
                        ? null
                        : [
                            BoxShadow(
                                color: AppColor.grey,
                                offset: Offset(3, 0),
                                blurRadius: 6),
                          ],
                  ),
                  child: Transform.rotate(
                    angle: -m.pi / 4,
                    child: Icon(icon ?? Icons.arrow_back_ios_new,
                        color: AppColor.brown, size: size),
                  )),
            ),
          ),
          Text(
            title ?? 'ToDo App',
            style: TextStyle(color: AppColor.blue, fontSize: size),
          ),
          Visibility(
            visible: showAvatar ?? true,
            child: GestureDetector(
              onTap: onAvatar,
              child: ClipOval(
                child: Container(
                  width: size * 2,
                  height: size * 2,
                  child: imageFile != null
                      ? Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/hoc.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
