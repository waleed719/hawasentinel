import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart' hide Column;
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
    Icons.psychology_outlined,
    Icons.notifications_outlined,
    Icons.bar_chart_outlined,
  ];
  static const _navIconsFilled = [
    Icons.home,
    Icons.psychology,
    Icons.notifications,
    Icons.bar_chart,
  ];
  static const _navLabels = ['Home', 'Agents', 'Alerts', 'Analytics'];

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
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(hasAlerts),
    );
  }

  Widget _buildBottomNav(bool hasAlerts) {
    return Container(
      decoration: const BoxDecoration(
        // matches bento-card bg from Stitch: surface-container #19211E
        color: AppTheme.surfaceContainer,
        border: Border(
          top: BorderSide(color: AppTheme.outlineVariant, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          // Stitch uses h-20 = 80px
          height: 80,
          child: Row(
            children: List.generate(4, (i) {
              final isSelected = i == _currentIndex;
              final color = isSelected
                  ? AppTheme.primary
                  : AppTheme.onSurfaceVariant;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = i),
                  splashColor: AppTheme.primary.withValues(alpha: 0.1),
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
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
                      const SizedBox(height: 4),
                      Text(
                        _navLabels[i],
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
