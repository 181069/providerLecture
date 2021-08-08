import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(

    join(await getDatabasesPath(), 'my_database.db'),

    onCreate: (db, version) {

      return db.execute(
        'CREATE TABLE fatima(id INTEGER PRIMARY KEY, description TEXT, DateTime date,TimeOfDay date,isDone INTEGER)',

      );
    },

    version: 1,
  );


  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'fatima',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Task>> fatima() async {

    final db = await database;


    final List<Map<String, dynamic>> maps = await db.query('fatima');


    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        dueDate: maps[i]['dueDate'],
        dueTime: maps[i]['dueTime'],
        isDone: maps[i]['isDone'],

      );
    });
  }

  Future<void> updateTask(Task task) async {

    final db = await database;


    await db.update(
      'fatima',
      task.toMap(),

      where: 'id = ?',

      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {

    final db = await database;


    await db.delete(
      'fatima',

      where: 'id = ?',

      whereArgs: [id],
    );
  }
 var task1 = Task(
    id:0,
    description: 'do english home work',
    dueDate: DateTime.utc(2021, 8, 9),
    dueTime: TimeOfDay(hour: 15, minute: 0),
    isDone: true,
  );

  await insertTask(task1);


  print(await fatima()); // Prints a list that include Fido.


  task1 = Task(
    id:0,
    description: 'do english home work',
    dueDate: DateTime.utc(2021, 8, 9),
    dueTime: TimeOfDay(hour: 15, minute: 0),
    isDone: true,
  );
  await updateTask(task1);


  print(await fatima());


  await deleteTask(task1.id);


  print(await fatima());
}






class Task {
  final int id;
  String description;
  DateTime dueDate;
  TimeOfDay dueTime;
  bool isDone;

  Task({
    @required this.id,
    @required this.description,
    this.dueDate,
    this.dueTime,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'dueDate': dueDate,
      'dueTime': dueTime,
      'isDone' : isDone,
    };
  }

  String toString() {
    return 'Task{id: $id, description: $description, dueDate: $dueDate,}';
  }
}