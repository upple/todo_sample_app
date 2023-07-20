import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../domain/todo.dart';
import '../domain/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  Database? _database;

  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos(
            id INTEGER PRIMARY KEY,
            title TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }

  Future<Database> _getDb() async {
    if (_database == null) {
      await _initializeDatabase();
    }
    return _database!;
  }

  @override
  Future<List<Todo>> fetchTodos() async {
    final db = await _getDb();
    final maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        isCompleted: maps[i]['isCompleted'] == 1,
      );
    });
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final db = await _getDb();
    await db.insert(
      'todos',
      {
        'id': todo.id,
        'title': todo.title,
        'isCompleted': todo.isCompleted ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final db = await _getDb();
    await db.update(
      'todos',
      {
        'title': todo.title,
        'isCompleted': todo.isCompleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  @override
  Future<void> deleteTodo(int id) async {
    final db = await _getDb();
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
