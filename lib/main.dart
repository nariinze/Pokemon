import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config.dart';
import 'controllers/favorite_controller.dart';
import 'models/user.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/auth_service.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local database (Hive) untuk data akun
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>(AuthService.boxName);

  // Favorite disimpan di Shared Preferences, controller dibuat sekali
  final favC = Get.put(FavoriteController(), permanent: true);

  // Cek sesi login dari Shared Preferences
  final username = await AuthService.currentUser();
  if (username != null) await favC.load(username);

  runApp(MyApp(isLoggedIn: username != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '${appConfig.titleLeft}${appConfig.titleRight}',
      theme: buildTheme(),
      // Halaman utama hanya bisa diakses jika sudah login
      home: isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}
