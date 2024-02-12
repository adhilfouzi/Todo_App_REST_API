import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_state.dart';
import 'package:todo_app_rest_api/data/repository/todo_reposiory.dart';
import 'package:todo_app_rest_api/presentation/todo_list.dart';

class EditTodo extends StatefulWidget {
  final Map todo;
  const EditTodo({super.key, required this.todo});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo['title'];
    descriptionController.text = widget.todo['description'];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(TodoRepository()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Edit Todo'),
        ),
        body: BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoUpdatedSuccess) {
              showSuccessMessage('Edit Success');
              titleController.clear();
              descriptionController.clear();
            } else if (state is TodoUpdateErrorState) {
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
                  final body = {
                    "title": titleController.text,
                    "description": descriptionController.text,
                    "is_completed": widget.todo['is_completed'],
                  };
                  context
                      .read<TodoBloc>()
                      .add(UpdateTodoEvent(widget.todo['_id'], body));
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const TodoList()),
                      (route) => false);
                },
                child: const Text('Update'),
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
