import 'package:flutter/material.dart';
import 'todo_item.dart';
import 'database.dart';
import 'todo_dao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter HOME PAGE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> todoList = [];
  late TodoDao myDAO;
  final TextEditingController _item = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  ToDoItem? selectedItem;
  late int selectedRowNum;

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase
        .databaseBuilder("app_database.db")
        .build()
        .then((database) {
      myDAO = database.todoDao;
      myDAO.getAllItems().then((listOfItems) {
        setState(() {
          todoList.clear();
          todoList.addAll(listOfItems);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: reactiveLayout(),
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    // Layout for different screen sizes
    if (width > 720) {
      return Row(
        children: [
          // Column for input fields and todo list
          Expanded(
            child: Column(
              children: [
                inputFieldsWidget(), // Always show input fields
                Expanded(
                    child: todoListWidget()), // Todo list takes remaining space
              ],
            ),
          ),
          // Column for details page (only if item is selected)
          if (selectedItem != null) Expanded(child: detailsPageWidget()),
        ],
      );
    } else {
      return Column(
        children: [
          inputFieldsWidget(), // Always show input fields
          if (selectedItem == null) Expanded(child: todoListWidget()),
          if (selectedItem != null) Expanded(child: detailsPageWidget()),
        ],
      );
    }
  }

  Widget inputFieldsWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _item,
              decoration: InputDecoration(hintText: "Type the item here"),
            ),
          ),
          SizedBox(width: 8), // Space between text fields
          Expanded(
            child: TextField(
              controller: _quantity,
              decoration: InputDecoration(hintText: "Type the quantity here"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_item.text.isNotEmpty && _quantity.text.isNotEmpty) {
                var newItem =
                    ToDoItem(ToDoItem.ID++, _item.text, _quantity.text);
                await myDAO.insertItem(newItem);
                setState(() {
                  todoList.add(newItem);
                  _item.text = "";
                  _quantity.text = "";
                });
              } else {
                const message = SnackBar(
                    content: Text("Please enter the item and quantity."));
                ScaffoldMessenger.of(context).showSnackBar(message);
              }
            },
            child: Text("Click to add"),
          ),
        ],
      ),
    );
  }

  Widget todoListWidget() {
    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, rowNum) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedItem = todoList[rowNum];
              selectedRowNum = rowNum;
            });
          },
          child: Center(
            child: Text(
              "${rowNum + 1}: ${todoList[rowNum].item} - Quantity: ${todoList[rowNum].quantity}",
            ),
          ),
        );
      },
    );
  }

  Widget detailsPageWidget() {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Item: ${selectedItem!.item}"),
              Text("Quantity: ${selectedItem!.quantity}"),
              Text("ID: ${selectedItem!.id}"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0), // Padding for spacing
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (selectedItem != null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Item deleted")));
                    setState(() {
                      myDAO.deleteItem(selectedItem!);
                      todoList.removeAt(selectedRowNum);
                      selectedItem = null; // Deselect after deleting
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No item selected")));
                  }
                },
                child: Text("Delete"),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedItem = null; // Close the details page
                  });
                },
                child: Text("Close"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
