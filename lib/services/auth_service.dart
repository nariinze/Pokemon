import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

/// Register  -> simpan akun ke Hive (local database)
/// Login     -> cek akun di Hive, simpan sesi ke Shared Preferences
/// Logout    -> hapus sesi di Shared Preferences
class AuthService {
  static const String boxName = 'users';
  static const String _kLoggedIn = 'isLoggedIn';
  static const String _kUsername = 'username';

  static Box<User> get _box => Hive.box<User>(boxName);

  /// return null = sukses, selain itu = pesan error
  static Future<String?> register(String username, String password) async {
    final key = username.toLowerCase();
    if (_box.containsKey(key)) return 'Username sudah terdaftar';
    await _box.put(key, User(username: username, password: password));
    return null;
  }

  static Future<String?> login(String username, String password) async {
    final user = _box.get(username.toLowerCase());
    if (user == null) return 'Akun tidak ditemukan, silakan daftar dulu';
    if (user.password != password) return 'Password salah';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kUsername, user.username);
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    await prefs.remove(_kUsername);
  }

  /// username yang sedang login, null jika belum login
  static Future<String?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_kLoggedIn) ?? false;
    return loggedIn ? prefs.getString(_kUsername) : null;
  }
}
