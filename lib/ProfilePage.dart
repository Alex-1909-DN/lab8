import 'package:flutter/material.dart';
import 'package:lab1/data_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await DataRepository.loadData();
    setState(() {
      _firstName.text = DataRepository.firstName;
      _lastName.text = DataRepository.lastName;
      _phone.text = DataRepository.phoneNumber;
      _email.text = DataRepository.email;
      _password.text = DataRepository.password;
    });
  }

  @override
  void dispose() {
    DataRepository.firstName = _firstName.text;
    DataRepository.lastName = _lastName.text;
    DataRepository.phoneNumber = _phone.text;
    DataRepository.email = _email.text;
    DataRepository.password = _password.text; // Save password here
    DataRepository.saveData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Welcome back " + DataRepository.loginName),
            TextField(
                controller: _firstName,
                decoration: const InputDecoration(labelText: "First Name")),
            TextField(
                controller: _lastName,
                decoration: const InputDecoration(labelText: "Last Name")),
            Row(
              children: [
                Flexible(
                  child: TextField(
                      controller: _phone,
                      decoration: const InputDecoration(labelText: "Phone")),
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () => launchUrl(Uri.parse("tel:${_phone.text}")),
                ),
                IconButton(
                  icon: Icon(Icons.sms),
                  onPressed: () => launchUrl(Uri.parse("sms: ${_phone.text}")),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: "Email")),
                ),
                IconButton(
                  icon: const Icon(Icons.mail),
                  onPressed: () =>
                      launchUrl(Uri.parse("mailto: ${_email.text}")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
