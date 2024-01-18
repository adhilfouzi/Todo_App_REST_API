import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Todo'),
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
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
        ElevatedButton(onPressed: updata, child: const Text('Update'))
      ]),
    );
  }

  void updata() async {
    final todo = widget.todo;
    final id = todo['_id'];
    final isdone = todo['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": isdone,
    };
    //  http.get(Uri.parse('https://api.nstack.in/v1/todos'));
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final responce = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (responce.statusCode == 200 || responce.statusCode == 201) {
      showSuccessMessage('Edit Success');
      titleController.clear();
      descriptionController.clear();
    } else {
      showErrorMessage('Edit failed: ${responce.statusCode}');
      print(responce.body);
    }
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
