import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutero/models/board.dart';
import 'package:tutero/models/item.dart';
import 'package:tutero/providers/main_screen_viewmodel.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size dpSize = MediaQuery.of(context).size;
    MainScreenViewModel vm = Provider.of<MainScreenViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project"),
      ),
      body: Container(
        width: dpSize.width,
        height: dpSize.height,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  vm.getBoards.map((e) => BoardWidget(context, vm, e)).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNewBoardDialog(
            context,
            vm,
          );
        },
        tooltip: 'Add New Board',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showNewBoardDialog(
    BuildContext context,
    MainScreenViewModel vm,
  ) {
    TextEditingController controller = TextEditingController();
    AlertDialog dialog = AlertDialog(
      title: const Text('Add Board'),
      content: TextField(
        controller: controller,
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("CANCEL"),
        ),
        MaterialButton(
          onPressed: () {
            vm.addBoard(controller.value.text);
            Navigator.pop(context);
          },
          child: const Text("SAVE"),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: true,
    );
  }

  void showNewItemDialog(
      BuildContext context, MainScreenViewModel vm, int boardId) {
    TextEditingController controller = TextEditingController();
    AlertDialog dialog = AlertDialog(
      title: const Text("Add Item"),
      content: TextField(
        controller: controller,
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("CANCEL"),
        ),
        MaterialButton(
          onPressed: () {
            vm.addItem(controller.value.text, boardId);
            Navigator.pop(context);
          },
          child: const Text("SAVE"),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: true,
    );
  }

  void showEditItemDialog(
      BuildContext context, MainScreenViewModel vm, Item item, int boardId) {
    TextEditingController controller = TextEditingController();
    AlertDialog dialog = AlertDialog(
      title: const Text("Edit Item"),
      content: TextField(
        controller: controller..text = item.name,
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("CANCEL"),
        ),
        MaterialButton(
          onPressed: () {
            vm.editItem(item, boardId, controller.value.text);
            //
            Navigator.pop(context);
          },
          child: const Text("SAVE"),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: true,
    );
  }

  void showDeleteItemDialog(
      BuildContext context, MainScreenViewModel vm, Item item, int boardId) {
    AlertDialog dialog = AlertDialog(
      title: Text("Delete ${item.name}"),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("CANCEL"),
        ),
        MaterialButton(
          onPressed: () {
            vm.deleteItem(item, boardId);
            Navigator.pop(context);
          },
          child: const Text("DELETE"),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: true,
    );
  }

  void showDeleteBoardDialog(
      BuildContext context, MainScreenViewModel vm, board, int boardId) {
    AlertDialog dialog = AlertDialog(
      title: Text("Delete ${board.name}"),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("CANCEL"),
        ),
        MaterialButton(
          onPressed: () {
            vm.deleteBoardItem(board);
            Navigator.pop(context);
          },
          child: const Text("DELETE"),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: true,
    );
  }

  Widget BoardWidget(
      BuildContext context, MainScreenViewModel vm, Board board) {
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Container(
        width: 300,
        height: MediaQuery.of(context).size.height * 0.9,
        color: const Color.fromRGBO(207, 207, 207, 1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      board.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      DateFormat('dd/MM')
                          .format(
                            DateTime.fromMicrosecondsSinceEpoch(
                              board.date * 1000,
                            ),
                          )
                          .toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: board.items
                      .map(
                          (e) => ItemWidget(context, e, board, vm, board.items))
                      .toList(),
                ),
              ),
              NewItemWidget(context, vm, board.id),
              Container(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    showDeleteBoardDialog(context, vm, board, board.id);
                  },
                  child: const Icon(Icons.delete, size: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ItemWidget(BuildContext context, Item item, Board board,
      MainScreenViewModel vm, listItems) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: 250,
        height: 40,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: listItems.indexOf(item) == 0
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        vm.moveItem(listItems, listItems.indexOf(item), false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("^"),
                      ),
                    ),
            ),
            Flexible(
              flex: 1,
              child: board.id == 0
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        vm.moveItemBoard(item, board, false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("<"),
                      ),
                    ),
            ),
            Flexible(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  showEditItemDialog(context, vm, item, board.id);
                },
                child: Text(item.name),
              ),
            ),
            Flexible(
              flex: 1,
              child: board.id == vm.getBoards.last.id
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        vm.moveItemBoard(item, board, true);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(">"),
                      ),
                    ),
            ),
            Flexible(
              flex: 1,
              child: listItems.indexOf(item) ==
                      listItems.indexOf(listItems.last)
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        vm.moveItem(listItems, listItems.indexOf(item), true);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("v"),
                      ),
                    ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showDeleteItemDialog(context, vm, item, board.id);
                },
                child: const Icon(Icons.delete, size: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget NewItemWidget(
      BuildContext context, MainScreenViewModel vm, int boardId) {
    return GestureDetector(
      onTap: () {
        showNewItemDialog(context, vm, boardId);
      },
      child: Container(
        width: 250,
        height: 40,
        color: Colors.white,
        child: const Center(child: Text("+")),
      ),
    );
  }
}
