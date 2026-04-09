import 'dart:async';
import 'package:flutter/material.dart';

import '../../widgets/card_widget.dart';
import '../../widgets/badge_widget.dart';
import '../../widgets/audio_level_indicator.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../services/voice_service.dart';


class HomeScreen extends StatefulWidget {
  final VoiceService voiceService; 

  const HomeScreen(
      {super.key, required this.voiceService}); 

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isListening = false;
  double audioLevel = 0;
  String? detectedCommand;

  final List<String> commands = ["Up", "Down", "Start", "Stop"];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  void toggleListening() {
    setState(() {
      isListening = !isListening;
    });

    if (isListening) {
      widget.voiceService.startListening(); // Используем widget.voiceService
      _startUIUpdate();
    } else {
      widget.voiceService.stopListening(); // Используем widget.voiceService
      _timer?.cancel();
    }
  }

  void _startUIUpdate() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;

      setState(() {
        audioLevel =
            widget.voiceService.audioLevel;

        final result = widget
            .voiceService.inferenceResult;

        if (result != null && result >= 0 && result < commands.length) {
          detectedCommand = commands[result];
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width >= 768;

    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 500 : 400,
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CardWidget(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: toggleListening,
                        child: Container(
                          width: isTablet ? 140 : 100,
                          height: isTablet ? 140 : 100,
                          decoration: BoxDecoration(
                            color: isListening
                                ? AppColors.danger
                                : AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isListening ? Icons.mic_off : Icons.mic,
                            size: isTablet ? 56 : 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isListening ? "Слушаю..." : "Нажмите для начала",
                        style: AppTextStyles.title,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (isListening) AudioLevelIndicator(level: audioLevel),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                if (detectedCommand != null)
                  CardWidget(
                    color: Colors.green[50],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'Команда: $detectedCommand',
                          style: AppTextStyles.command,
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),
                CardWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Доступные команды',
                        style: AppTextStyles.title,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: commands.map((cmd) {
                          return BadgeWidget(
                            text: cmd,
                            isActive: detectedCommand == cmd,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
