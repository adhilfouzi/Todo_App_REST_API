import 'package:flutter/material.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoadingState extends TodoState {}

class TodoLoadedSuccess extends TodoState {
  final List<dynamic> todo;
  TodoLoadedSuccess({required this.todo});
}

class TodoErrorState extends TodoState {
  final String errorMessage;
  TodoErrorState(this.errorMessage);
}

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

class TodoAddingState extends TodoState {}

class TodoAddedSuccess extends TodoState {}

class TodoAddErrorState extends TodoState {
  final String message;

  TodoAddErrorState(this.message);
}

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

class TodoUpdatingState extends TodoState {}

class TodoUpdatedSuccess extends TodoState {}

class TodoUpdateErrorState extends TodoState {
  final String message;

  TodoUpdateErrorState(this.message);
}
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

class TodoDeletingState extends TodoState {}

class TodoDeletedState extends TodoState {}

class TodoDeleteErrorState extends TodoState {
  final String message;

  TodoDeleteErrorState(this.message);
}
