import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import '../theme.dart';

/// Background + logo + kartu putih transparan untuk Login & Register
class AuthShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;

  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.bg, AppColors.surface2, AppColors.bg],
              ),
            ),
          ),
          const Positioned(top: -90, right: -70, child: _Glow(AppColors.primary)),
          const Positioned(bottom: -110, left: -90, child: _Glow(AppColors.accent)),
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: .5),
                                blurRadius: 30,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(appConfig.logoIcon,
                              size: 46, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        Text(title,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        Text(subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.muted)),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: .85),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: .08)),
                          ),
                          child: child,
                        ),
                      ],
                    ),
                  ),
                ),
                if (showBack)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  const _Glow(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: .35), Colors.transparent],
        ),
      ),
    );
  }
}
