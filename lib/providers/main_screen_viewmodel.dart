import 'package:flutter/material.dart';
import 'package:tutero/models/board.dart';
import 'package:tutero/models/item.dart';
import 'package:uuid/uuid.dart';

class MainScreenViewModel extends ChangeNotifier {
  final List<Board> _boards = <Board>[];
  List<Board> get getBoards => _boards;
  final List<Item> _items = <Item>[];
  List<Item> get getItems => _items;
  MainScreenViewModel() {
    loadData();
  }

  List<Item> sampleItems = [
    Item(
      id: "0",
      name: "Item 0",
    ),
    Item(
      id: "1",
      name: "Item 1",
    ),
    Item(
      id: "2",
      name: "Item 2",
    ),
  ];

  List<Board> sampleBoards = [
    Board(id: 0, name: "To Do", date: 1578296400000, items: []),
    Board(id: 1, name: "In Progress", date: 1598296400000, items: []),
    Board(id: 2, name: "Completed", date: 1628296400000, items: []),
    Board(id: 3, name: "Verified", date: 1618296400000, items: []),
  ];

  loadData() {
    sampleBoards[0].items.addAll(sampleItems);
    _boards.addAll(sampleBoards);
  }

  addItem(String name, int boardId) {
    Item newItem = Item(id: const Uuid().toString(), name: name);

    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].id == boardId) {
        _boards[i].items.add(newItem);
      }
    }
    notifyListeners();
  }

  addBoard(String name) {
    int now = DateTime.now().millisecondsSinceEpoch;
    dynamic _boardsLength = _boards.length;
    Board newBoard = Board(id: _boardsLength, name: name, date: now, items: []);
    _boards.add(newBoard);
    notifyListeners();
  }

  moveItemBoard(Item item, Board currentBoard, bool isToNext) {
    int targetBoardId = isToNext ? currentBoard.id + 1 : currentBoard.id - 1;

    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].id == currentBoard.id) {
        _boards[i].items.remove(item);
      }

      if (_boards[i].id == targetBoardId) {
        _boards[i].items.add(item);
      }
    }

    notifyListeners();
  }

  moveItem(listItems, int itemIndex, bool isBelow) {
    if (isBelow) {
      dynamic temp = listItems[itemIndex];
      listItems[itemIndex] = listItems[itemIndex + 1];
      listItems[itemIndex + 1] = temp;
    } else {
      dynamic temp = listItems[itemIndex];
      listItems[itemIndex] = listItems[itemIndex - 1];
      listItems[itemIndex - 1] = temp;
    }
    notifyListeners();
  }

  bool isLastBoard(Board board) {
    return board.id == _boards[_boards.length].id;
  }

  editItem(Item item, int boardId, String newName) {
    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].id == boardId) {
        for (int k = 0; k < _boards[i].items.length; k++) {
          if (_boards[i].items[k].id == item.id) {
            _boards[i].items[k].name = newName;
          }
        }
      }
    }
    notifyListeners();
  }

  deleteItem(Item item, int boardId) {
    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].id == boardId) {
        for (int k = 0; k < _boards[i].items.length; k++) {
          if (_boards[i].items[k].id == item.id) {
            _boards[i].items.remove(item);
          }
        }
      }
    }
    notifyListeners();
  }

  deleteBoardItem(board) {
    _boards.remove(board);

    notifyListeners();
  }
}
