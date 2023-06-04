import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app_11_5/components/custom_app_bar.dart';
import 'package:todo_app_11_5/components/custom_item.dart';
import 'package:todo_app_11_5/components/custom_search_box.dart';
import 'package:todo_app_11_5/models/account_model.dart';
import 'package:todo_app_11_5/models/todo_model.dart';
import 'package:todo_app_11_5/pages/delete_page.dart';
import 'package:todo_app_11_5/pages/login_page.dart';
import 'package:todo_app_11_5/pages/change_password_page.dart';
import 'package:todo_app_11_5/resources/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/shared_prefs.dart';
import 'package:path/path.dart' as p;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> itemColors = [
    AppColor.brown,
    AppColor.yellow,
    AppColor.green2,
    AppColor.red
  ];
  int selectedIndex = 0;

  List<ToDoModel> _foundTodo = [];
  List<ToDoModel> searchLists = [];
  List<ToDoModel> todoLists = [];
  List<ToDoModel> doneLists = [];
  List<ToDoModel> doingLists = [];

  final _addController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isShow = false;
  bool _addShow = true;
  final SharedPrefs _prefs = SharedPrefs();
  File? _image;

  AccountModel account = AccountModel();
  double size = 30;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDrawer = false;

  @override
  void initState() {
    super.initState();
    for (var acc in accountList1) {
      setState(() {
        account = acc;
      });
    }
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
    _prefs.getTodos().then((value) {
      todoLists = value ?? [];
      searchLists = [...todoLists];
      _foundTodo = [...searchLists];
      doneLists = [
        ...todoLists.where((element) => (element.isDone ?? false) == true)
      ];
      doingLists = [
        ...todoLists.where((element) => (element.isDone ?? false) == false)
      ];
      setState(() {});
    });
  }

  void _addNew(String addNew) {
    int id = 1;
    if (todoLists.isNotEmpty) {
      id = (todoLists.last.id ?? 0) + 1;
    }
    ToDoModel todo = ToDoModel()
      ..id = id
      ..title = addNew;
    todoLists.add(todo);
    // todoLists.add(
    //   ToDoModel(id: DateTime.now().millisecondsSinceEpoch, title: addNew),
    // );
    _searchController.clear();
    _addController.clear();
    _foundTodo = [...todoLists];
    searchLists = [...todoLists];
    _prefs.addTodos(todoLists);
    doingLists = [
      ...todoLists.where((element) => (element.isDone ?? false) == false)
    ];

    setState(() {});
  }

  void _checkExist(String addNew) {
    bool isExist = false;
    for (ToDoModel todo in todoLists) {
      if (todo.title?.toLowerCase() == addNew.toLowerCase()) {
        isExist = true;
        break;
      }
    }
    if (isExist) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Seem like the job content is the same!!",
              style: TextStyle(color: AppColor.red),
            ),
            content: const Text("Do you want to continue?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  _addNew(addNew);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      _addNew(addNew);
    }
  }

  void _deleteAlert(ToDoModel todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You have not done that yet!!'),
          content: const Text('Continue to delete?'),
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
                  _foundTodo.remove(todo);
                  todoLists.remove(todo);
                  doneLists.remove(todo);
                  doingLists.remove(todo);
                  deleteList1.add(todo);
                  _prefs.addTodos(todoLists);
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

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePermanent = await saveFilePermanently(image.path);
      final imagePath = imagePermanent.path;

      setState(() {
        this._image = imagePermanent;
      });

      await _prefs.setImagePath(imagePath);
    } on PlatformException catch (e) {
      print('Failed to pick: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = p.basename(imagePath);
    final permanentPath = '${directory.path}/$name';

    final imageFile = File(imagePath);
    final permanentFile = await imageFile.copy(permanentPath);

    return permanentFile;
  }

  void _launchURL() async {
    const url = 'https://www.facebook.com/profile.php?id=100022521426223';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Future.value(false);
        if (isDrawer == false) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else {
          setState(() {
            isDrawer = false;
          });
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        onDrawerChanged: (isOpened) {
          setState(() {
            isDrawer = isOpened;
            print(isDrawer);
          });
        },
        drawer: Drawer(
          backgroundColor: AppColor.bgDrawer,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      currentAccountPicture: ClipOval(
                        child: Container(
                          width: size * 2,
                          height: size * 2,
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/hoc.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      accountName: Text('ThaiHoc App'),
                      accountEmail: Text('thaihoc2le2@gmail.com'),
                      decoration: BoxDecoration(
                          color: AppColor.tran,
                          image: DecorationImage(
                              image: AssetImage('assets/images/univers.png'),
                              fit: BoxFit.cover)),
                    ),
                    ListTile(
                      leading: Icon(Icons.facebook),
                      title: Text('Developer Profile'),
                      onTap: () {
                        _launchURL();
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_support),
                      title: Text('Help'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      hoverColor: AppColor.green,
                      leading: Icon(Icons.password),
                      title: Text('Change password'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Route route = PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ChangePassword(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child;
                          },
                        );
                        Navigator.push(context, route);
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text('Do you want to Log out?'),
                        title: Row(
                          children: const [
                            Icon(
                              Icons.emoji_emotions,
                              color: AppColor.brown,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Log out!',
                              style: TextStyle(
                                color: AppColor.brown,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              accountList1.clear();
                              _prefs.addAccount(accountList1);
                              print(accountList1);
                              Route route = MaterialPageRoute(
                                  builder: (context) => LoginPage());
                              Navigator.push(context, route);
                            },
                            child: const Text('Yes 😭'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No 🥰'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        appBar: CustomAppBar(
          icon: Icons.menu,
          imageFile: _image,
          onAvatar: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Choose from Gallery'),
                      onTap: () {
                        pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Take a Photo'),
                      onTap: () {
                        pickImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          leftPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    CustomSearchBox(
                      controller: _searchController,
                      onChanged: (_searchController) {
                        setState(() {
                          if (_searchController.isNotEmpty) {
                            _foundTodo = [
                              ...searchLists
                                  .where((element) => (element.title ?? '')
                                      .toLowerCase()
                                      .contains(
                                          _searchController.toLowerCase()))
                                  .toList()
                            ];
                          } else {
                            _foundTodo = [...searchLists];
                          }
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                          color: AppColor.grey, thickness: 1.5, height: 31.5),
                    ),
                    Flexible(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Visibility(
                              visible: _foundTodo.isEmpty ? true : false,
                              child: const Center(
                                  child: Text(
                                'Todo List is empty',
                                style: TextStyle(
                                    color: AppColor.grey,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
                              ))),
                          for (ToDoModel todo in _foundTodo.reversed)
                            Dismissible(
                              key: UniqueKey(),
                              direction: todo.isDone ?? false
                                  ? DismissDirection.startToEnd
                                  : DismissDirection.none,
                              onDismissed: (direction) {
                                setState(() {
                                  _foundTodo.remove(todo);
                                  todoLists.remove(todo);
                                  doneLists.remove(todo);
                                  doingLists.remove(todo);
                                  deleteList1.add(todo);
                                  _prefs.addTodos(todoLists);
                                  _prefs.addDelete(deleteList1);
                                });
                              },
                              background: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20)
                                        .copyWith(bottom: 15),
                                decoration: BoxDecoration(
                                  color: AppColor.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.delete, color: AppColor.white),
                                  ],
                                ),
                              ),
                              child: CustomItem(
                                todo: todo,
                                onChange: () {
                                  setState(() {
                                    todo.isDone = !(todo.isDone ?? false);
                                    for (ToDoModel td in todoLists) {
                                      if (td.id == todo.id) {
                                        td.isDone = todo.isDone;
                                      }
                                    }
                                    if (todo.isDone!) {
                                      doingLists.remove(todo);
                                      doneLists.add(todo);
                                      if (selectedIndex == 1) {
                                        _foundTodo.remove(todo);
                                      }
                                    } else {
                                      doneLists.remove(todo);
                                      doingLists.add(todo);
                                      if (selectedIndex == 2) {
                                        _foundTodo.remove(todo);
                                      }
                                    }
                                    _prefs.addTodos(todoLists);
                                  });
                                },
                                onDelete: () {
                                  if (todo.isDone ?? false) {
                                    setState(() {
                                      _foundTodo.remove(todo);
                                      doneLists.remove(todo);
                                      doingLists.remove(todo);
                                      todoLists.remove(todo);
                                      deleteList1.add(todo);
                                      _prefs.addTodos(todoLists);
                                      _prefs.addDelete(deleteList1);
                                    });
                                  } else {
                                    _deleteAlert(todo);
                                  }
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
              Positioned(
                bottom: 10,
                left: 20,
                right: 100,
                child: Visibility(
                  visible: _isShow,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20)
                        .copyWith(top: 5, bottom: 5),
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
                      autofocus: true,
                      controller: _addController,
                      decoration: const InputDecoration(
                        hintText: 'Add new to do here',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 10,
                child: GestureDetector(
                  onTap: () {
                    if (_addController.text.isNotEmpty) {
                      _checkExist(_addController.text);
                    } else {
                      setState(() {
                        _isShow = !_isShow;
                      });
                    }
                  },
                  child: Visibility(
                    visible: _addShow,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: AppColor.blue,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
            index: 0,
            height: 60,
            backgroundColor: Colors.transparent,
            animationDuration: const Duration(milliseconds: 300),
            color: AppColor.btColor,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
              if (selectedIndex == 0) {
                setState(() {
                  _addShow = true;
                  _foundTodo = [...todoLists];
                  searchLists = [...todoLists];
                  _prefs.addTodos(todoLists);
                });
              } else if (selectedIndex == 1) {
                setState(() {
                  _isShow = false;
                  _addShow = false;
                  _foundTodo = doingLists;
                  searchLists = doingLists;
                  _prefs.addTodos(todoLists);
                  _searchController.clear();
                });
              } else if (selectedIndex == 2) {
                setState(() {
                  _isShow = false;
                  _addShow = false;
                  _foundTodo = doneLists;
                  searchLists = doneLists;
                  _prefs.addTodos(todoLists);
                  _searchController.clear();
                });
              } else if (selectedIndex == 3) {
                Route route = PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DeletePage(todoLists: todoLists),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                );

                Navigator.push(context, route);
                setState(() {
                  _searchController.clear();
                  _foundTodo = [...todoLists];
                  searchLists = [...todoLists];
                  _prefs.addTodos(todoLists);
                });
              }
            },
            items: [
              _buildNavigationBarItem(Icons.home, 'Home', 0),
              _buildNavigationBarItem(
                  Icons.check_box_outline_blank, 'Doing', 1),
              _buildNavigationBarItem(Icons.check_box, 'Done', 2),
              _buildNavigationBarItem(Icons.delete, 'Deleted', 3),
            ]),
      ),
    );
  }

  Widget _buildNavigationBarItem(IconData icon, String label, int index) {
    Color iconColor =
        selectedIndex == index ? itemColors[index] : AppColor.white;
    Color textColor =
        selectedIndex == index ? itemColors[index] : AppColor.white;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(height: 2),
        Visibility(
          visible: selectedIndex == index,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
