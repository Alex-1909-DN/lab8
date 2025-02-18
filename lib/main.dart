import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final TextEditingController _item = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final List<String> _itemList = [];
  final List<String> _quantityList = [];

  void _addItem() {
    if (_item.text.isNotEmpty && _quantity.text.isNotEmpty) {
      setState(() {
        _itemList.add(_item.text);
        _quantityList.add(_quantity.text);
      });
      _item.clear();
      _quantity.clear();
    }
  }

  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item?'),
        content: const Text('Do you want to remove this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _itemList.removeAt(index);
                _quantityList.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _item,
                      decoration: const InputDecoration(
                          hintText: "Type the item here",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _quantity,
                      decoration: const InputDecoration(
                        hintText: "Type the quantity here",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addItem,
                    child: const Text('Click here'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _itemList.isEmpty
                  ? const Center(child: Text(' '))
                  : ListView.builder(
                      itemCount: _itemList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${index + 1}: ${_itemList[index]} quantity: ${_quantityList[index]}',
                              ),
                            ],
                          ),
                          onLongPress: () => _removeItem(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
