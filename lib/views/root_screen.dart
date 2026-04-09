import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'performance/performance_screen.dart';
import 'settings/settings_screen.dart';
import '../theme/colors.dart';
import '../services/voice_service.dart';


class RootScreen extends StatefulWidget {
  final VoiceService voiceService; 

  const RootScreen(
      {super.key, required this.voiceService});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(voiceService: widget.voiceService),
      PerformanceScreen(voiceService: widget.voiceService),
      SettingsScreen(voiceService: widget.voiceService),
    ];

    _initModel();
  }

  Future<void> _initModel() async {
    final loaded = await widget.voiceService.initModel();
    if (loaded) {
      print("✅ Model loaded in RootScreen");
    } else {
      print("❌ Model failed to load in RootScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      body: Row(
        children: [
          if (isTablet)
            Container(
              width: 250,
              color: Colors.white,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: ListView(
                      children: [
                        _navItem(0, Icons.mic, 'Распознавание', isTablet),
                        _navItem(
                            1, Icons.bar_chart, 'Производительность', isTablet),
                        _navItem(2, Icons.settings, 'Настройки', isTablet),
                      ],
                    ),
                  ),
                  _buildModelInfo(),
                ],
              ),
            ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: isTablet
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.mic), label: 'Распознавание'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart), label: 'Производительность'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Настройки'),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aurora ML Voice',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Распознавание речи', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildModelInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Текущая модель:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.model_training, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.voiceService.selectedModelType,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: widget.voiceService.isListening
                      ? Colors.green
                      : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.voiceService.isListening ? 'Слушаю...' : '⏸ Ожидание',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.voiceService.isListening
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, bool isTablet) {
    bool isActive = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primaryLight,
                border: Border(
                    right: BorderSide(color: AppColors.primary, width: 4)),
              )
            : null,
        child: Row(
          children: [
            Icon(icon, color: isActive ? AppColors.primary : Colors.grey[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.primary : Colors.grey[700],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
