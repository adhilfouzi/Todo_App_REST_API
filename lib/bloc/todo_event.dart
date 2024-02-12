part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

final class GetTodoEvent extends TodoEvent {}

final class AddTodoEvent extends TodoEvent {
  final String title;
  final String description;
  AddTodoEvent({required this.title, required this.description});
}

class UpdateTodoEvent extends TodoEvent {
  final String id;
  final Map body;
  UpdateTodoEvent(this.id, this.body);
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  DeleteTodoEvent(this.id);
}
