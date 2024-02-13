import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:todo_app_rest_api/bloc/todo_state.dart';
import 'package:todo_app_rest_api/data/repository/todo_reposiory.dart';
part 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;
  TodoBloc(this.todoRepository) : super(TodoInitial()) {
    on<GetTodoEvent>(_onGetTodoEvent);
    on<AddTodoEvent>(_onAddTodoEvent);
    on<UpdateTodoEvent>(_onUpdateTodoEvent);
    on<DeleteTodoEvent>(_onDeleteTodoEvent);
  }

  void _onGetTodoEvent(GetTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoadingState());
    try {
      final todo = await todoRepository.fetchTodo();
      emit(TodoLoadedSuccess(todo: todo!));
    } catch (e) {
      log(e.toString());
      emit(TodoErrorState(e.toString()));
    }
  }

  void _onAddTodoEvent(AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoAddingState());
    try {
      final title = event.title;
      final description = event.description;
      final body = {
        "title": title,
        "description": description,
        "is_completed": false,
      };
      final response = await todoRepository.addData(body);
      if (response) {
        emit(TodoAddedSuccess());
      } else {
        emit(TodoAddErrorState('Creation failed'));
      }
    } catch (e) {
      log(e.toString());
      emit(TodoAddErrorState(e.toString()));
    }
  }

  void _onUpdateTodoEvent(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoUpdatingState());
    try {
      final responce = await TodoRepository().updatedata(event.id, event.body);
      if (responce) {
        emit(TodoUpdatedSuccess());
      } else {
        emit(TodoUpdateErrorState('Edit failed'));
      }
    } catch (e) {
      log(e.toString());
      emit(TodoUpdateErrorState(e.toString()));
    }
  }

  void _onDeleteTodoEvent(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoDeletingState());
    try {
      final responce = await TodoRepository().delectById(event.id);
      if (responce) {
        emit(TodoDeletedState());
        final todo = await todoRepository.fetchTodo();
        emit(TodoLoadedSuccess(todo: todo!));
      } else {
        emit(TodoDeleteErrorState('Deletion Failed'));
      }
    } catch (e) {
      log(e.toString());
      emit(TodoDeleteErrorState(e.toString()));
    }
  }
}
