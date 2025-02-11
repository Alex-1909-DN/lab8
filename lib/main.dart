import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
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
      home: const MyHomePage(title: 'Login Page'),
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
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();

  String? passWord;
  bool _obsecurePassWord = true;
  var _imageSource = "images/question-mark.png";

  bool _obsecurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    String? savedUsername = await _storage.getString('username');
    String? savedPassword = await _storage.getString('password');
    if (savedUsername != null && savedPassword != null) {
      setState(() {
        _login.text = savedUsername;
        _password.text = savedPassword;
      });
      _showSnackbar();
    }
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('Previous login name and passwords have been loaded!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _login.clear();
              _password.clear();
            });
          },
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Your Login Information?'),
        content: const Text(
            'Do you want to save your login information for next time?'),
        actions: [
          TextButton(
            onPressed: () async {
              await _storage.setString('username', _login.text);
              await _storage.setString('password', _password.text);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () async {
              await _storage.remove('username');
              await _storage.remove('password');
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _handlePasswordValidation() {
    setState(() {
      String password = _password.text;
      _obsecurePassword = false;
      if (password == "QWERTY123") {
        _imageSource = "images/idea.png";
      } else {
        _imageSource = "images/stop.png";
      }
    });
  }

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _login,
              decoration: const InputDecoration(
                  hintText: "Please enter user name",
                  labelText: "Login",
                  border: OutlineInputBorder()),
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                hintText: "Please enter password",
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: _obsecurePassWord,
            ),
            ElevatedButton(
              onPressed: () {
                _handlePasswordValidation();
                _handleLogin();
              },
              child: const Text("Login"),
            ),
            Image.asset(_imageSource, width: 300, height: 300),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
