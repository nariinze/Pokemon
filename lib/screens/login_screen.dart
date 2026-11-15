import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../controllers/favorite_controller.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/auth_shell.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userC = TextEditingController();
  final _passC = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _userC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final error = await AuthService.login(_userC.text.trim(), _passC.text);
    if (!mounted) return;

    if (error != null) {
      setState(() => _loading = false);
      showAppSnackBar(context, error,
          icon: Icons.error_outline_rounded, color: Colors.redAccent);
      return;
    }

    final username = await AuthService.currentUser();
    await Get.find<FavoriteController>().load(username!);
    if (!mounted) return;
    Get.offAll(() => const MainScreen(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Welcome Back!',
      subtitle: appConfig.loginSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _userC,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Username wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passC,
              obscureText: _obscure,
              onFieldSubmitted: (_) => _login(),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(_obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.black),
                    )
                  : const Text('Login'),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum punya akun?',
                    style: TextStyle(color: AppColors.muted)),
                TextButton(
                  onPressed: () => Get.to(() => const RegisterScreen()),
                  child: const Text('Daftar',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
