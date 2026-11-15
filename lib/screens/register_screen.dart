import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../services/auth_service.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/auth_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _userC.dispose();
    _passC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final error = await AuthService.register(_userC.text.trim(), _passC.text);
    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      showAppSnackBar(context, error,
          icon: Icons.error_outline_rounded, color: Colors.redAccent);
      return;
    }

    Get.back(); // kembali ke halaman login
    showAppSnackBar(context, 'Registrasi berhasil, silakan login');
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      showBack: true,
      title: 'Buat Akun',
      subtitle: appConfig.registerSubtitle,
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
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Username wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passC,
              obscureText: _obscure,
              textInputAction: TextInputAction.next,
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
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password wajib diisi';
                if (v.length < 6) return 'Minimal 6 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmC,
              obscureText: _obscure,
              onFieldSubmitted: (_) => _register(),
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
                prefixIcon: Icon(Icons.lock_reset_rounded),
              ),
              validator: (v) =>
                  v != _passC.text ? 'Password tidak sama' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _register,
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.black),
                    )
                  : const Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
