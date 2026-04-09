import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const CardWidget({required this.child, this.padding, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? AppColors.bgCard,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
