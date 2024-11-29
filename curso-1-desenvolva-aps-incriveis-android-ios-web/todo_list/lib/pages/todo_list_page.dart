import 'package:flutter/material.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

import '../models/todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  String? errorText;

  @override
  void initState() {
    super.initState();

    setState(() {
      todoRepository.getTodoList().then((value) => todos = value);
    });
  }

  void onDelete(Todo todo) {
    int positionTodoInList = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.title} foi removida com sucesso',
        style: const TextStyle(color: Color(0xff060708)),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: const Color(0xff00d7f3),
        onPressed: () {
          setState(() {
            todos.insert(positionTodoInList, todo);
            todoRepository.saveTodoList(todos);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Ex. Estudar Flutter',
                            errorText: errorText,
                            labelStyle: const TextStyle(
                              color: Color(0xff00d7f3),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff00d7f3),
                                width: 2,
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                          onPressed: () {
                            String text = todoController.text;

                            if (text.isEmpty) {
                              setState(() {
                                errorText = 'O título não pode ser vazio!';
                              });
                              return;
                            }

                            setState(() {
                              todos.add(Todo(
                                title: text,
                                date: DateTime.now(),
                              ));
                              errorText = null;
                            });

                            todoController.clear();
                            todoRepository.saveTodoList(todos);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00d7f3),
                              padding: const EdgeInsets.all(12),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero)),
                          child: const Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text('Você possui ${todos.length} tarefas pendentes'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Desejar limpar todas as tarefas?'),
                                  content: const Text(
                                      'Você tem certeza que deseja apagar todas as tarefas'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cancelar',
                                        style:
                                            TextStyle(color: Color(0xff00d7f3)),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        setState(() {
                                          todos.clear();
                                        });

                                        todoRepository.saveTodoList(todos);
                                      },
                                      child: const Text(
                                        'Limpar tudo',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff00d7f3),
                            padding: const EdgeInsets.all(12),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        child: const Text('Limpar tudo'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
