import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static String loginName = "Guest";
  static String password = "";
  static String firstName = "";
  static String lastName = "";
  static String phoneNumber = "";
  static String email = "";

  static final EncryptedSharedPreferences _storage =
      EncryptedSharedPreferences();

  /// **Loads saved user data from EncryptedSharedPreferences**
  static Future<void> loadData() async {
    loginName = await _storage.getString('username') ?? "Guest";
    firstName = await _storage.getString('firstName') ?? "";
    lastName = await _storage.getString('lastName') ?? "";
    phoneNumber = await _storage.getString('phoneNumber') ?? "";
    email = await _storage.getString('email') ?? "";
    password = await _storage.getString('password') ?? "";
  }

  /// **Saves user data into EncryptedSharedPreferences**
  static Future<void> saveData() async {
    await _storage.setString('username', loginName);
    await _storage.setString('firstName', firstName);
    await _storage.setString('lastName', lastName);
    await _storage.setString('phoneNumber', phoneNumber);
    await _storage.setString('email', email);
    await _storage.setString('password', password);
  }
}
