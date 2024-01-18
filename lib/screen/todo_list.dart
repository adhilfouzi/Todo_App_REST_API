import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app_rest_api/screen/add_todo.dart';
import 'package:todo_app_rest_api/screen/edit_todo.dart';
import 'package:todo_app_rest_api/service/todo_service.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isloading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
                child: Text(
              'NO TODO ITEM',
              style: Theme.of(context).textTheme.headlineSmall,
            )),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          log('Edit selected with ID: $id');
                          final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EditTodo(todo: item)));
                          if (result == true) {
                            fetchTodo();
                          }
                        } else if (value == 'delete') {
                          log('Delete selected with ID: $id');
                          setState(() {
                            deleteById(id);
                          });
                        } else {
                          log('error');
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          )
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddTodoPage()));
            if (result == true) {
              fetchTodo();
            }
          },
          label: const Text('Add Todo')),
    );
  }

  Future<void> deleteById(String id) async {
    log('Deleting item with id: $id');

    try {
      final isDone = await TodoService.delectById(id);

      if (isDone) {
        setState(() {
          items = items.where((element) => element['_id'] != id).toList();
        });
        showSuccessMessage('Deletion completed successfully');
        log('Deletion completed successfully');
      } else {
        showErrorMessage('Error deleting item');

        log('Error deleting item.');
      }
    } catch (error) {
      log('Error during deletion: $error');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();

    if (response != null) {
      setState(() {
        items = response;
        log(items.toString());
      });
    } else {
      showErrorMessage('Something Missing');
    }
    setState(() {
      isloading = false;
    });
  }
}
