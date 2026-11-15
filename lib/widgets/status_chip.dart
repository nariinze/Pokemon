import 'package:flutter/material.dart';
import '../theme.dart';

class StatusDot extends StatelessWidget {
  final String label;
  final double size;
  const StatusDot({super.key, required this.label, this.size = 9});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.badgeColor(label);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withValues(alpha: .6), blurRadius: 6)],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  const StatusChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.badgeColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: .5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusDot(label: label),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 13)),
        ],
      ),
    );
  }
}
