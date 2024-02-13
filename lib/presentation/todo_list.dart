import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_state.dart';
import 'package:todo_app_rest_api/data/widget/message_widget.dart';
import 'package:todo_app_rest_api/presentation/add_todo.dart';
import 'package:todo_app_rest_api/presentation/edit_todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TodoBloc>().add(GetTodoEvent());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Note Pad'),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoErrorState) {
            SnackbarUtils.showError(context, 'Error: ${state.errorMessage}');
          }
        },
        builder: (context, state) {
          if (state is TodoErrorState) {
            return Center(
                child: Text(
              'Error: ${state.errorMessage}',
            ));
          } else if (state is! TodoLoadedSuccess) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final items = state.todo;
            if (items.isEmpty) {
              return const Center(
                child: Text("No Note found"),
              );
            }
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    item['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item['description'],
                    maxLines: 2,
                    textWidthBasis: TextWidthBasis.longestLine,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditTodo(todo: item)));
                      } else if (value == 'delete') {
                        context.read<TodoBloc>().add(DeleteTodoEvent(id));
                      } else {
                        log('error on PopupMenuButton');
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
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddTodoPage()));
          },
          label: const Text('Add Note')),
    );
  }
}
