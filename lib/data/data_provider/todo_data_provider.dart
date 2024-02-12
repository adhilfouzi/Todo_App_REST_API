import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app_rest_api/data/secret/secret_key.dart';

class TodoDataProvider {
  static Future<int> deleteTodoData(String id) async {
    final response = await http.delete(Uri.parse('$openApiKey/$id'));
    return response.statusCode;
  }

  static Future<List?> getTodo() async {
    final response = await http.get(Uri.parse('$openApiKey?page=1&limit=20'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<int> putTodoData(String id, Map body) async {
    final responce = await http.put(Uri.parse('$openApiKey/$id'),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return responce.statusCode;
  }

  static Future<int> postTodoData(Map body) async {
    final responce = await http.post(Uri.parse(openApiKey),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return responce.statusCode;
  }
}
