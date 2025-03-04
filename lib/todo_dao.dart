import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'todo_item.dart';

@dao
abstract class TodoDao {
  @Query("Select * from TodoItem")
  Future<List<TodoItem>> getAllItems();
  @insert
  Future<void> insertItems(TodoItem itm);
  @delete
  Future<void> deleteItems(TodoItem itm);
}
