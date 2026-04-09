import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;
  final Color? color;

  const ButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.outlined = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width >= 768;

    final buttonColor = color ?? AppColors.primary;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: outlined ? Colors.transparent : buttonColor,
        foregroundColor: outlined ? buttonColor : Colors.white,
        side: outlined ? BorderSide(color: buttonColor, width: 2) : null,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16 : 12,
          horizontal: isTablet ? 20 : 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: outlined ? 0 : 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isTablet ? 24 : 20),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              text,
              style:
                  AppTextStyles.button.copyWith(fontSize: isTablet ? 18 : 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
