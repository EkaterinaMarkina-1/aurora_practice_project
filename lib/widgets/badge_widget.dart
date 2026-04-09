import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class BadgeWidget extends StatelessWidget {
  final String text;
  final bool isActive;
  final bool outlined;

  const BadgeWidget({
    super.key,
    required this.text,
    this.isActive = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Border? border;

    if (outlined) {
      bgColor = Colors.transparent;
      textColor = AppColors.primary;
      border = Border.all(color: AppColors.primary, width: 1.5);
    } else if (isActive) {
      bgColor = AppColors.primary;
      textColor = Colors.white;
      border = null;
    } else {
      bgColor = Colors.grey.shade200;
      textColor = Colors.grey.shade800;
      border = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: border,
      ),
      child: Text(
        text,
        style: AppTextStyles.subtitle.copyWith(
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}
