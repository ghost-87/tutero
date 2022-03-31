import 'package:tutero/models/item.dart';

class Board {
  int id;
  String name;
  int date;
  List<Item> items;

  Board({
    required this.id,
    required this.name,
    required this.items,
    required this.date,
  });
}
