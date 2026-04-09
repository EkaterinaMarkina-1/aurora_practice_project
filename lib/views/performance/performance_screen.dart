import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/button_widget.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../services/voice_service.dart';

class Metric {
  final double inferenceTime;
  final double ramUsage;
  final DateTime timestamp;

  Metric({
    required this.inferenceTime,
    required this.ramUsage,
    required this.timestamp,
  });
}

class PerformanceScreen extends StatefulWidget {
  final VoiceService voiceService;

  const PerformanceScreen(
      {super.key, required this.voiceService}); 

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  List<Metric> metrics = [];
  Metric? currentMetric;
  bool isMonitoring = false;
  int frameCount = 0;
  final Random _random = Random();
  Timer? _monitoringTimer;

  @override
  void dispose() {
    _monitoringTimer?.cancel();
    super.dispose();
  }

  void startMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer =
        Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!isMonitoring) {
        timer.cancel();
        return;
      }

      final newMetric = Metric(
        inferenceTime: 15 + _random.nextDouble() * 35, 
        ramUsage: 45 + _random.nextDouble() * 15, 
        timestamp: DateTime.now(),
      );

      setState(() {
        currentMetric = newMetric;
        metrics = [...metrics, newMetric];
        if (metrics.length > 200) metrics.removeAt(0);
        frameCount++;
      });
    });
  }

  void toggleMonitoring() {
    setState(() => isMonitoring = !isMonitoring);
    if (isMonitoring) {
      startMonitoring();
    } else {
      _monitoringTimer?.cancel();
    }
  }

  void resetMetrics() {
    setState(() {
      metrics.clear();
      currentMetric = null;
      frameCount = 0;
    });
  }

  double get avgInferenceTime => metrics.isEmpty
      ? 0
      : metrics.map((m) => m.inferenceTime).reduce((a, b) => a + b) /
          metrics.length;

  double get avgRamUsage => metrics.isEmpty
      ? 0
      : metrics.map((m) => m.ramUsage).reduce((a, b) => a + b) / metrics.length;

  double get minInferenceTime =>
      metrics.isEmpty ? 0 : metrics.map((m) => m.inferenceTime).reduce(min);

  double get maxInferenceTime =>
      metrics.isEmpty ? 0 : metrics.map((m) => m.inferenceTime).reduce(max);

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width >= 768;
    double padding = isTablet ? 24 : 16;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          CardWidget(
            child: Row(
              children: [
                Icon(Icons.model_training, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Текущая модель:',
                          style: AppTextStyles.subtitle),
                      Text(
                        widget.voiceService.selectedModelType,
                        style: AppTextStyles.title.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.voiceService.isListening
                        ? Colors.green
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.voiceService.isListening ? 'Активен' : 'Ожидание',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          CardWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Мониторинг производительности',
                    style: AppTextStyles.title),
                const SizedBox(height: 8),
                Text(
                  'Запустите мониторинг для измерения времени инференса и потребления памяти. Приложение будет симулировать обработку аудио-кадров каждые 200 мс и собирать метрики.',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: isMonitoring ? 'Остановить' : 'Начать мониторинг',
                        icon: isMonitoring ? Icons.pause : Icons.play_arrow,
                        onPressed: toggleMonitoring,
                        color:
                            isMonitoring ? AppColors.danger : AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ButtonWidget(
                        text: 'Сбросить',
                        icon: Icons.refresh,
                        outlined: true,
                        onPressed: metrics.isEmpty ? null : resetMetrics,
                      ),
                    ),
                  ],
                ),
                if (isMonitoring) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text('Обработано кадров: $frameCount',
                          style: AppTextStyles.subtitle),
                    ],
                  )
                ]
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (currentMetric != null)
            CardWidget(
              color: Colors.blue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Время обработки последнего кадра',
                      style: AppTextStyles.subtitle),
                  const SizedBox(height: 4),
                  Text('${currentMetric!.inferenceTime.toStringAsFixed(2)} мс',
                      style: AppTextStyles.title
                          .copyWith(color: AppColors.primary)),
                  Text('RAM: ${currentMetric!.ramUsage.toStringAsFixed(2)} МБ',
                      style: AppTextStyles.subtitle),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CardWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Среднее время инференса',
                          style: AppTextStyles.subtitle),
                      Text('${avgInferenceTime.toStringAsFixed(2)} мс',
                          style: AppTextStyles.title),
                      Text(
                          'Мин: ${minInferenceTime.toStringAsFixed(2)} • Макс: ${maxInferenceTime.toStringAsFixed(2)}',
                          style: AppTextStyles.subtitle.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CardWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Среднее потребление RAM',
                          style: AppTextStyles.subtitle),
                      Text('${avgRamUsage.toStringAsFixed(2)} МБ',
                          style: AppTextStyles.title),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CardWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('График времени инференса', style: AppTextStyles.title),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: metrics.takeLast(100).map((metric) {
                      double height = (metric.inferenceTime / 50) *
                          120; 
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          height: height,
                          color: AppColors.primary,
                        ),
                      );
                    }).toList(),
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

extension TakeLast<T> on List<T> {
  List<T> takeLast(int n) => length <= n ? this : sublist(length - n);
}
