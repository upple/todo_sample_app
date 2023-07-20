import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/todo.dart';
import '../data/todo_repository_impl.dart';

abstract class TodoRepository {
  Future<List<Todo>> fetchTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
}

final todoRepositoryProvider = StateProvider<TodoRepository>((ref) => TodoRepositoryImpl());
