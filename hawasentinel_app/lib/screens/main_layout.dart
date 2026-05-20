import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'agents_screen.dart';
import 'alerts_screen.dart';
import 'analytics_screen.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    AgentsScreen(),
    AlertsScreen(),
    AnalyticsScreen(),
  ];

  // Stitch nav icons: home, psychology, notifications, bar_chart
  static const _navIcons = [
    Icons.home_outlined,
    Icons.smart_toy_outlined,
    Icons.notifications_outlined,
    Icons.bar_chart_outlined,
  ];
  static const _navIconsFilled = [
    Icons.home,
    Icons.smart_toy,
    Icons.notifications,
    Icons.bar_chart,
  ];
  // static const _navLabels = ['Home', 'Agents', 'Alerts', 'Analytics'];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final appState = context.watch<AppState>();
    final hasAlerts = appState.currentSimulation != null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(hasAlerts),
    );
  }

  Widget _buildBottomNav(bool hasAlerts) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppTheme.outlineVariant, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) {
                final isSelected = i == _currentIndex;
                final color = isSelected
                    ? AppTheme.primary
                    : AppTheme.onSurfaceVariant;
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            isSelected ? _navIconsFilled[i] : _navIcons[i],
                            color: color,
                            size: 26,
                          ),
                          // Red dot on Alerts tab (index 2)
                          if (i == 2 && hasAlerts)
                            Positioned(
                              top: -2,
                              right: -4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
