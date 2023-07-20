import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/domain/todo.dart';
import 'core/presentation/todo_viewmodel.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TodoApp(),
    ),
  );
}

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: const TodoListScreen(),
      ),
    );
  }
}

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenConsumerState();
}

class _TodoListScreenConsumerState extends ConsumerState<TodoListScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> addTodo({required String text}) async {
    Todo newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: text,
      isCompleted: false,
    );
    await ref.watch(todoViewModelProvider.notifier).addTodo(newTodo);
  }

  void toggleTodoStatus(int id, bool isCompleted) async {
    final todoList = ref.watch(todoViewModelProvider);
    Todo updatedTodo = todoList.firstWhere((todo) => todo.id == id);
    updatedTodo.isCompleted = isCompleted;
    await ref.watch(todoViewModelProvider.notifier).updateTodo(updatedTodo);
  }

  void deleteTodo(int id) async {
    await ref.watch(todoViewModelProvider.notifier).deleteTodo(id);
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoViewModelProvider);
    return Scaffold(
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          final todo = todoList[index];
          return ListTile(
            title: Text(todo.title),
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (newValue) => toggleTodoStatus(todo.id, newValue!),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteTodo(todo.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final textField = TextEditingController();
          bool ret = await showDialog<bool>(
              context: context,
              builder: (context) {
                return textInputDialog(context, textField);
              }) ?? false;
          if (ret) {
            addTodo(text: textField.text);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget textInputDialog(BuildContext context, TextEditingController controller) {
  return AlertDialog(
    title: const Text('Add a Todo'),
    content: TextField(
      decoration: const InputDecoration(
        hintText: 'Type a content',
      ),
      controller: controller,
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text('cancel'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: const Text('conform'),
      ),
    ],
  );
}
