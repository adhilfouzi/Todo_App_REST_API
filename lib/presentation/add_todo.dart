import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_state.dart';
import 'package:todo_app_rest_api/data/repository/todo_reposiory.dart';
import 'package:todo_app_rest_api/data/widget/message_widget.dart';
import 'package:todo_app_rest_api/presentation/todo_list.dart';

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    TextEditingController descriptionController = TextEditingController();
    return BlocProvider(
      create: (context) => TodoBloc(TodoRepository()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Note'),
        ),
        body: BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoAddedSuccess) {
              titleController.clear();
              descriptionController.clear();
            } else if (state is TodoAddErrorState) {
              SnackbarUtils.showError(context, state.message);
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: 'Title'),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 10,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
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
                  SnackbarUtils.showSuccess(context, 'Creation Success');
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
