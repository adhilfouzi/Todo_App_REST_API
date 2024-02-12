import 'package:todo_app_rest_api/data/data_provider/todo_data_provider.dart';

class TodoRepository {
  Future<bool> delectById(String id) async {
    final response = await TodoDataProvider.deleteTodoData(id);
    return response == 200;
  }

  Future<List?> fetchTodo() async {
    return await TodoDataProvider.getTodo();
  }

  Future<bool> updatedata(String id, Map body) async {
    final statusCode = await TodoDataProvider.putTodoData(id, body);
    return (statusCode == 200 || statusCode == 201);
  }

  Future<bool> addData(Map body) async {
    final statusCode = await TodoDataProvider.postTodoData(body);
    return statusCode == 201;
  }
}
