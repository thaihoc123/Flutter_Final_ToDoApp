import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_11_5/models/account_model.dart';
import '../models/todo_model.dart';

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // shared prefference todoLists
  Future<List<ToDoModel>?> getTodos() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('todoLists');
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<ToDoModel> todoLists = maps.map((e) => ToDoModel.fromJson(e)).toList();
    return todoLists;
  }

  Future<void> addTodos(List<ToDoModel> todoLists) async {
    List<Map<String, dynamic>> maps = todoLists.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('todoLists', jsonEncode(maps));
  }

  // shared prefference deleteLists
  Future<List<ToDoModel>?> getDelete() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('deleteLists');
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<ToDoModel> deleteLists =
        maps.map((e) => ToDoModel.fromJson(e)).toList();
    return deleteLists;
  }

  Future<void> addDelete(List<ToDoModel> deleteLists) async {
    List<Map<String, dynamic>> maps =
        deleteLists.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('deleteLists', jsonEncode(maps));
  }

  // shared preferences accountlogined
  Future<List<AccountModel>?> getAccount() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('account');
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<AccountModel> account =
        maps.map((e) => AccountModel.fromJson(e)).toList();
    return account;
  }

  Future<void> addAccount(List<AccountModel> account) async {
    List<Map<String, dynamic>> maps = account.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('account', jsonEncode(maps));
  }

  // shared preferences signup account
  Future<List<AccountModel>?> getSignup() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('signup');
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<AccountModel> signup =
        maps.map((e) => AccountModel.fromJson(e)).toList();
    return signup;
  }

  Future<void> addSignup(List<AccountModel> signup) async {
    List<Map<String, dynamic>> maps = signup.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('signup', jsonEncode(maps));
  }

  //shared prefferences imagePick
   Future<String?> getImagePath() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString('imagePath');
  }

  Future<void> setImagePath(String imagePath) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('imagePath', imagePath);
  }
}
