import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/todo.dart';
import '../domain/todo_repository.dart';

class TodoViewModel extends StateNotifier<List<Todo>> {
  final TodoRepository repository;

  TodoViewModel(this.repository) : super([]) {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    state = await repository.fetchTodos();
  }

  Future<void> addTodo(Todo todo) async {
    await repository.addTodo(todo);
    fetchTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await repository.updateTodo(todo);
    fetchTodos();
  }

  Future<void> deleteTodo(int id) async {
    await repository.deleteTodo(id);
    fetchTodos();
  }
}

final todoViewModelProvider = StateNotifierProvider<TodoViewModel, List<Todo>>(
    (ref) => TodoViewModel(ref.watch(todoRepositoryProvider)));
