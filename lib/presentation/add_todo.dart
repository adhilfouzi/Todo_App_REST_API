import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_state.dart';
import 'package:todo_app_rest_api/data/repository/todo_reposiory.dart';
import 'package:todo_app_rest_api/presentation/todo_list.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    TextEditingController descriptionController = TextEditingController();
    return BlocProvider(
      create: (context) => TodoBloc(TodoRepository()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Todo'),
        ),
        body: BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoAddedSuccess) {
              showSuccessMessage('Creation Success');
              titleController.clear();
              descriptionController.clear();
            } else if (state is TodoAddErrorState) {
              showErrorMessage(state.message);
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;
                  log('message');
                  context.read<TodoBloc>().add(AddTodoEvent(
                        title: title,
                        description: description,
                      ));
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const TodoList()),
                      (route) => false);
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pop(true);
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
}
