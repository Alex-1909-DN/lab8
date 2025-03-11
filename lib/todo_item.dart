import 'package:floor/floor.dart';

@entity
class ToDoItem {
  static int ID = 1;

  @primaryKey
  final int id;
  final String item;
  final String quantity;

  ToDoItem(this.id, this.item, this.quantity) {
    if (id > ID) {
      ID = id + 1;
    }
  }
}
