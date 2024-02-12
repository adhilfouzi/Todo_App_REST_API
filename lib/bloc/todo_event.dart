part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

final class GetTodoEvent extends TodoEvent {}

final class AddTodoEvent extends TodoEvent {}

final class UpdateTodoEvent extends TodoEvent {}

final class DeleteTodoEvent extends TodoEvent {}
