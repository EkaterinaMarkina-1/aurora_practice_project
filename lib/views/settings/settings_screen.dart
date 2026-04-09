import 'package:flutter/material.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/badge_widget.dart';
import '../../widgets/button_widget.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../services/voice_service.dart';


class SettingsScreen extends StatefulWidget {
  final VoiceService voiceService; 

  const SettingsScreen(
      {super.key, required this.voiceService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool audioPermission = true;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Модель TensorFlow Lite',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    _buildModelOption(
                      VoiceService.MODEL_FLOAT32,
                      'Float32 (Высокая точность)',
                      '2.4 МБ',
                      'Максимальная точность, но медленнее',
                    ),
                    _buildModelOption(
                      VoiceService.MODEL_INT8,
                      'Int8 (Квантованная)',
                      '0.6 МБ',
                      'Быстрая работа и низкая нагрузка на CPU',
                      recommended: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          CardWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.mic,
                      size: isTablet ? 24 : 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Настройки аудио',
                      style: AppTextStyles.title,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSwitchOption(
                  label: 'Разрешение микрофона',
                  description: 'Разрешить приложению доступ к микрофону',
                  value: audioPermission,
                  onChanged: (val) {
                    setState(() {
                      audioPermission = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  text: 'Применить',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Настройки сохранены')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ButtonWidget(
                  text: 'Сброс',
                  outlined: true,
                  onPressed: () {
                    setState(() {
                      audioPermission = true;
                    });
                    widget.voiceService.setModelType(VoiceService.MODEL_INT8);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModelOption(
      String value, String label, String size, String description,
      {bool recommended = false}) {
    bool isTablet = MediaQuery.of(context).size.width >= 768;
    bool selected = widget.voiceService.selectedModelType == value;

    return GestureDetector(
      onTap: () async {
        final success = await widget.voiceService.switchModel(value);
        if (success) {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Модель изменена на $label')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ошибка при смене модели'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withAlpha((0.1 * 255).round())
              : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.subtitle,
                  ),
                ),
                const SizedBox(width: 8),
                if (recommended) const BadgeWidget(text: 'Рекомендуется'),
                const SizedBox(width: 4),
                BadgeWidget(
                  text: size,
                  outlined: true,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption({
    required String label,
    required String description,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
