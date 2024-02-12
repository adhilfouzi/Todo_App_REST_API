import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_rest_api/bloc/todo_state.dart';
import 'package:todo_app_rest_api/data/repository/todo_reposiory.dart';

part 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;
  TodoBloc(this.todoRepository) : super(TodoInitial()) {
    on<GetTodoEvent>(_onGetTodoEvent);
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
}

  // @override
  // Stream<TodoState> mapEventToState(TodoEvent event) async* {
  //   if (event is GetTodoEvent) {
  //     yield* _mapGetTodoEventToState();
  //   } else if (event is AddTodoEvent) {
  //     yield* _mapAddTodoEventToState(event);
  //   } else if (event is UpdateTodoEvent) {
  //     yield* _mapUpdateTodoEventToState(event);
  //   } else if (event is DeleteTodoEvent) {
  //     yield* _mapDeleteTodoEventToState(event);
  //   }
  // }

  // Stream<TodoState> _mapGetTodoEventToState() async* {
  //   yield TodoLoadingState();
  //   try {
  //     final todo = await todoRepository.fetchTodo();
  //     yield TodoLoadedSuccess(todo: todo!);
  //   } catch (e) {
  //     log(e.toString());
  //     yield TodoErrorState(e.toString());
  //   }
  // }

  // Stream<TodoState> _mapAddTodoEventToState(AddTodoEvent event) async* {
  //   yield TodoAddingState();
  //   try {
  //     final success = await todoRepository.addData(event.body);
  //     if (success) {
  //       yield TodoAddedState();
  //     } else {
  //       yield TodoAddErrorState("Failed to add todo.");
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     yield TodoAddErrorState(e.toString());
  //   }
  // }

  // Stream<TodoState> _mapUpdateTodoEventToState(UpdateTodoEvent event) async* {
  //   yield TodoUpdatingState();
  //   try {
  //     final success = await todoRepository.updatedata(event.id, event.body);
  //     if (success) {
  //       yield TodoUpdatedState();
  //     } else {
  //       yield TodoUpdateErrorState("Failed to update todo.");
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     yield TodoUpdateErrorState(e.toString());
  //   }
  // }

  // Stream<TodoState> _mapDeleteTodoEventToState(DeleteTodoEvent event) async* {
  //   yield TodoDeletingState();
  //   try {
  //     final success = await todoRepository.delectById(event.id);
  //     if (success) {
  //       yield TodoDeletedState();
  //     } else {
  //       yield TodoDeleteErrorState("Failed to delete todo.");
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     yield TodoDeleteErrorState(e.toString());
  //   }
  // }
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todo_app_rest_api/data/repository/todo_reposiory.dart';

// part 'todo_event.dart';
// part 'todo_state.dart';

// class TodoBloc extends Bloc<TodoEvent, TodoState> {
//   TodoBloc() : super(TodoInitial()) {
//     on<GetTodoEvent>(_onGetTodoEvent);
//   }
//   void _onGetTodoEvent(GetTodoEvent event, Emitter<TodoState> emit) async {
//     emit(TodoLoadingState());
//     try {
//       final todo = await todoRepository.fetchTodo();
//       emit(TodoLoadedSuccess(todo: todo!));
//     } catch (e) {
//       log(e.toString());
//       emit(TodoErrorState(e.toString()));
//     }
//   }
// }
