import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AudioLevelIndicator extends StatelessWidget {
  final double level; // 0-100%

  const AudioLevelIndicator({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (level.clamp(0, 100)) / 100,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text('Уровень звука',
            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
