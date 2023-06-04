import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_11_5/components/custom_app_bar.dart';
import 'package:todo_app_11_5/components/custom_item.dart';
import 'package:todo_app_11_5/components/custom_search_box.dart';
import 'package:todo_app_11_5/models/todo_model.dart';
import 'package:todo_app_11_5/pages/home_page.dart';
import 'package:todo_app_11_5/resources/app_color.dart';
import '../services/shared_prefs.dart';

class DeletePage extends StatefulWidget {
  final List<ToDoModel> todoLists;

  const DeletePage({super.key, required this.todoLists});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  List<Color> itemColors = [
    AppColor.brown,
    AppColor.yellow,
    AppColor.green2,
    AppColor.red
  ];
  int selectedIndex = 3;

  List<ToDoModel> _foundTodo = [];
  final _searchController = TextEditingController();
  final SharedPrefs _prefs = SharedPrefs();
  File? _image;

  @override
  void initState() {
    super.initState();
    loadSavedImage();
    _getTodos();
  }

  Future<void> loadSavedImage() async {
    final imagePath = await _prefs.getImagePath();

    if (imagePath != null && imagePath.isNotEmpty) {
      final imageFile = File(imagePath);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _getTodos() {
    _prefs.getDelete().then((value) {
      deleteList1 = value ?? [];
      _foundTodo = [...deleteList1];
      setState(() {});
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
          imageFile: _image,
          leftPressed: () {
            Route route = PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
            Navigator.push(context, route);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CustomSearchBox(
                controller: _searchController,
                onChanged: (_searchController) {
                  setState(() {
                    if (_searchController.isNotEmpty) {
                      _foundTodo = [
                        ...deleteList1
                            .where((element) => (element.title ?? '')
                                .toLowerCase()
                                .contains(_searchController.toLowerCase()))
                            .toList()
                      ];
                    } else {
                      _foundTodo = [...deleteList1];
                    }
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:
                    Divider(color: AppColor.grey, thickness: 1.5, height: 31.5),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Visibility(
                        visible: _foundTodo.isEmpty ? true : false,
                        child: const Center(
                            child: Text(
                          'Deleted list is empty',
                          style: TextStyle(
                              color: AppColor.grey,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ))),
                    for (ToDoModel todo in _foundTodo.reversed)
                      Dismissible(
                        direction: DismissDirection.horizontal,
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            setState(() {
                              _foundTodo.remove(todo);
                              deleteList1.remove(todo);
                              _prefs.addDelete(deleteList1);
                            });
                          } else if (direction == DismissDirection.startToEnd) {
                            setState(() {
                              _foundTodo.remove(todo);
                              widget.todoLists.add(todo);
                              deleteList1.remove(todo);
                              _prefs.addTodos(widget.todoLists);
                              _prefs.addDelete(deleteList1);
                            });
                          }
                        },
                        secondaryBackground: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20)
                              .copyWith(bottom: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.red,
                          ),
                          child: const Icon(
                            Icons.delete_forever,
                            color: AppColor.white,
                            size: 30,
                          ),
                        ),
                        background: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20)
                              .copyWith(bottom: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.yellow,
                          ),
                          child: const Icon(
                            Icons.restore,
                            color: AppColor.white,
                            size: 30,
                          ),
                        ),
                        child: CustomItem(
                          isRestore: true,
                          icon: Icons.delete_forever,
                          todo: todo,
                          onRestore: () {
                            setState(() {
                              _foundTodo.remove(todo);
                              widget.todoLists.add(todo);
                              deleteList1.remove(todo);
                              _prefs.addTodos(widget.todoLists);
                              _prefs.addDelete(deleteList1);
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _foundTodo.remove(todo);
                              deleteList1.remove(todo);
                              _prefs.addDelete(deleteList1);
                            });
                          },
                        ),
                      ),
                    const SizedBox(height: 60)
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
            index: 3,
            height: 60,
            backgroundColor: Colors.transparent,
            animationDuration: const Duration(milliseconds: 300),
            color: AppColor.btColor,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
              if (value == 1) {
                if (deleteList1.isEmpty) {
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Restore All!'),
                        content:
                            const Text('Do you really want to Restore All!'),
                        actions: [
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              setState(() {
                                _foundTodo.clear();
                                widget.todoLists.addAll(deleteList1);
                                deleteList1.clear();

                                _prefs.addTodos(widget.todoLists);

                                _prefs.addDelete(deleteList1);
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
              if (value == 2) {
                if (deleteList1.isEmpty) {
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete All!'),
                        content:
                            const Text('Do you really want to Delete All!'),
                        actions: [
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              setState(() {
                                _foundTodo.clear();
                                deleteList1.clear();
                                _prefs.addDelete(deleteList1);
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
              if (value == 0) {
                Route route = PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                );
                Navigator.push(context, route);
              }
            },
            items: [
              _buildNavigationBarItem(Icons.home, 'Home', AppColor.brown, 0),
              _buildNavigationBarItem(
                  Icons.restore, 'Restore all', AppColor.yellow, 1),
              _buildNavigationBarItem(
                  Icons.delete_forever, 'Delete all', AppColor.green, 2),
              _buildNavigationBarItem(Icons.delete, 'Deleted', AppColor.red, 3),
            ]),
      ),
    );
  }

  Widget _buildNavigationBarItem(
      IconData icon, String label, Color color, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 2),
        Visibility(
          visible: selectedIndex != index,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
