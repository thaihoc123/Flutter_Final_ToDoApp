import 'package:flutter/material.dart';
import 'package:todo_app_11_5/models/todo_model.dart';
import 'package:todo_app_11_5/resources/app_color.dart';

class CustomItem extends StatelessWidget {
  final VoidCallback? onChange;
  final ToDoModel? todo;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final IconData? icon;
  final IconData? icon2;
  final bool? isRestore;
  const CustomItem({
    super.key,
    this.todo,
    this.onChange,
    this.onDelete,
    this.icon = Icons.delete,
    this.icon2 = Icons.restore,
    this.isRestore,
    this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 3),
              color: AppColor.grey,
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              todo?.isDone == true
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: AppColor.blue,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  todo?.title ?? '',
                  style: TextStyle(
                      decoration: todo?.isDone == true
                          ? TextDecoration.lineThrough
                          : null),
                ),
              ),
            ),
            Visibility(
              visible: isRestore ?? false,
              child: GestureDetector(
                onTap: onRestore,
                child: CircleAvatar(
                  backgroundColor: AppColor.yellow,
                  child: Icon(
                    icon2,
                    size: 20,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: onDelete,
              child: CircleAvatar(
                backgroundColor: AppColor.red,
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
