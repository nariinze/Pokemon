import 'package:flutter/material.dart';
import '../theme.dart';

void showAppSnackBar(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_rounded,
  Color color = AppColors.primary,
  SnackBarAction? action,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      action: action,
      content: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}
