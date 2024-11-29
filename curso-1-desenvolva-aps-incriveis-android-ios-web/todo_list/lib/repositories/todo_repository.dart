import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/todo.dart';

class TodoRepository {
  final String __todoListKey = 'todo_list';

  Future<void> saveTodoList(List<Todo> todos) async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    final String jsonList = json.encode(todos);
    instance.setString(__todoListKey, jsonList);
  }

  Future<List<Todo>> getTodoList() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    final String jsonString = instance.getString(__todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }
}
