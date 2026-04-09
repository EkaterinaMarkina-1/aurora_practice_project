import 'package:flutter/material.dart';
import 'views/root_screen.dart';
import 'theme/colors.dart';
import 'theme/typography.dart';
import 'services/voice_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Starting application...");

  final voiceService = VoiceService();

  runApp(AuroraApp(voiceService: voiceService));
}

class AuroraApp extends StatelessWidget {
  final VoiceService voiceService;

  const AuroraApp({super.key, required this.voiceService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora ML Voice',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: const TextTheme(
          titleLarge: AppTextStyles.title,
          bodyMedium: AppTextStyles.subtitle,
        ),
      ),
      home: RootScreen(voiceService: voiceService),
    );
  }
}
