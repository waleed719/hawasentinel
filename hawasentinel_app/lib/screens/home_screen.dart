import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final sim = appState.currentSimulation;
    final aqi = sim?.inputData.aqi ?? 623;
    final crisisLevel = sim?.crisisLevel ?? 'HAZARDOUS';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _TopAppBar(onRefresh: () => appState.triggerSimulation('mock')),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroAqiCard(
                    aqi: aqi,
                    crisisLevel: crisisLevel,
                    isLoading: appState.isLoading,
                  ),
                  const SizedBox(height: 16),
                  _RunAgentsButton(appState: appState),
                  const SizedBox(height: 24),
                  const _DailyForecastGraph(),
                  const SizedBox(height: 24),
                  _AgentActionsSection(sim: sim),
                  const SizedBox(height: 24),
                  // const _ForecastCard(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Run Agents CTA Button
// ─────────────────────────────────────────────────────────────────────────────

class _RunAgentsButton extends StatelessWidget {
  final AppState appState;
  const _RunAgentsButton({required this.appState});

  @override
  Widget build(BuildContext context) {
    final isLoading = appState.isLoading;

    return Row(
      children: [
        // Primary: Run Agent Analysis
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: isLoading ? null : () => appState.triggerSimulation('mock'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              decoration: BoxDecoration(
                color: isLoading
                    ? AppTheme.primary.withValues(alpha: 0.4)
                    : AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.onPrimary,
                      ),
                    )
                  else
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: AppTheme.onPrimary,
                      size: 20,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    isLoading ? 'Analyzing...' : 'Run Agent Analysis',
                    style: GoogleFonts.inter(
                      color: AppTheme.onPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Secondary: Fast Replay (hazard scenario)
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: isLoading
                ? null
                : () => appState.triggerSimulation('hazardous'),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isLoading
                      ? AppTheme.outlineVariant
                      : AppTheme.primary.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    color: isLoading
                        ? AppTheme.onSurfaceVariant
                        : AppTheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Fast Replay',
                    style: GoogleFonts.inter(
                      color: isLoading
                          ? AppTheme.onSurfaceVariant
                          : AppTheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top App Bar
// ─────────────────────────────────────────────────────────────────────────────

class _TopAppBar extends StatelessWidget {
  final VoidCallback onRefresh;
  const _TopAppBar({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          decoration: const BoxDecoration(
            color: AppTheme.background,
            border: Border(
              bottom: BorderSide(color: AppTheme.outlineVariant, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'HawaSentinel AI',
                      style: GoogleFonts.inter(
                        color: AppTheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Lahore, Punjab',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.background,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero AQI Card
// ─────────────────────────────────────────────────────────────────────────────

class _HeroAqiCard extends StatelessWidget {
  final int aqi;
  final String crisisLevel;
  final bool isLoading;

  const _HeroAqiCard({
    required this.aqi,
    required this.crisisLevel,
    required this.isLoading,
  });

  String _getAsset(int aqi) {
    if (aqi <= 100) return 'assets/green.png';
    if (aqi <= 200) return 'assets/yellow.png';
    return 'assets/red.png';
  }

  Color _getBgColor(int aqi) {
    if (aqi <= 100) return const Color(0xFFAFCD5D);
    if (aqi <= 200) return const Color(0xFFA78426);
    return const Color(0xFF3A0002); // Dark red
  }

  Color _getTextColor(int aqi) {
    if (aqi <= 100) return const Color(0xFF14532D); // Dark green
    if (aqi <= 200) return const Color(0xFF451A03); // Dark brown
    return const Color(0xFFF96060); // Bright reddish pink
  }

  Color _getBadgeColor(int aqi) {
    if (aqi <= 100) return const Color(0xFF22C55E);
    if (aqi <= 200) return const Color(0xFFF59E0B);
    return const Color(0xFFE14F4F);
  }

  String _getCategoryText(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  @override
  Widget build(BuildContext context) {
    final asset = _getAsset(aqi);
    final bgColor = _getBgColor(aqi);
    final textColor = _getTextColor(aqi);
    final badgeColor = _getBadgeColor(aqi);
    final secondaryTextColor = aqi <= 200
        ? Colors.black87
        : Colors.white.withValues(alpha: 0.9);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(asset),
          fit: BoxFit.fitHeight,
          opacity: 0.5,
          alignment: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 20,
          bottom: 20,
          right: 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current AQI',
              style: GoogleFonts.inter(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isLoading ? '--' : '$aqi',
              style: GoogleFonts.inter(
                color: textColor,
                fontSize:
                    58, // slightly reduced to prevent wrapping on narrow screens
                fontWeight: FontWeight.w800,
                height: 1.0,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                crisisLevel.toUpperCase(),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PM2.5 | ${_getCategoryText(aqi)}',
              style: GoogleFonts.inter(
                color: secondaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Feels like 48°C\nHumidity 72%',
              style: GoogleFonts.inter(
                color: secondaryTextColor.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mini Stat Row
// ─────────────────────────────────────────────────────────────────────────────

class _DailyForecastGraph extends StatefulWidget {
  const _DailyForecastGraph();

  @override
  State<_DailyForecastGraph> createState() => _DailyForecastGraphState();
}

class _DailyForecastGraphState extends State<_DailyForecastGraph> {
  bool _isLoading = true;
  List<FlSpot> _spots = [];
  List<String> _days = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=31.558&longitude=74.3507&hourly=us_aqi',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final hourly = data['hourly'];
        final List<dynamic> times = hourly['time'];
        final List<dynamic> aqis = hourly['us_aqi'];

        Map<String, double> dailyMax = {};
        for (int i = 0; i < times.length; i++) {
          final timeStr = times[i] as String;
          final date = timeStr.substring(0, 10);
          final aqi = (aqis[i] as num?)?.toDouble() ?? 0.0;
          if (!dailyMax.containsKey(date) || aqi > dailyMax[date]!) {
            dailyMax[date] = aqi;
          }
        }

        final sortedDates = dailyMax.keys.toList()..sort();
        List<FlSpot> spots = [];
        List<String> days = [];
        for (int i = 0; i < sortedDates.length && i < 7; i++) {
          final date = sortedDates[i];
          final aqi = dailyMax[date]!;
          spots.add(FlSpot(i.toDouble(), aqi));
          // parse short weekday
          final parsedDate = DateTime.parse(date);
          final weekday = [
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat',
            'Sun',
          ][parsedDate.weekday - 1];
          days.add(weekday);
        }

        if (mounted) {
          setState(() {
            _spots = spots;
            _days = days;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1F2937)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_spots.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 220,
      padding: const EdgeInsets.only(top: 20, bottom: 16, left: 16, right: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Daily Forecast (Max AQI)',
              style: GoogleFonts.inter(
                color: AppTheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppTheme.outlineVariant.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.jetBrainsMono(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _days[index],
                              style: GoogleFonts.jetBrainsMono(
                                color: AppTheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots,
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.primary,
                          strokeWidth: 2,
                          strokeColor: const Color(0xFF111827),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Active Agent Actions
// ─────────────────────────────────────────────────────────────────────────────

class _AgentActionsSection extends StatelessWidget {
  final dynamic sim;
  const _AgentActionsSection({required this.sim});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Agent Actions',
              style: GoogleFonts.inter(
                color: AppTheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'View All',
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ActionCard(
          agentName: 'Sentinel-1 (Gov)',
          timeAgo: '2m ago',
          title: 'Initiate Code Red Alert',
          description:
              'Broadcast emergency SMOG advisory to all registered municipal contacts in Zone A.',
          leftBorderColor: AppTheme.error,
          badgeLabel: 'SENT',
          badgeBg: AppTheme.error,
          pulsing: false,
          iconColor: AppTheme.error,
        ),
        const SizedBox(height: 12),
        _ActionCard(
          agentName: 'Agri-Monitor-X',
          timeAgo: '15m ago',
          title: 'Dispatch Drone Fleet',
          description:
              'Investigate thermal anomalies near Kasur border indicating new stubble fires.',
          leftBorderColor: AppTheme.tertiaryContainer,
          badgeLabel: 'ACTIVE',
          badgeBg: AppTheme.tertiaryContainer,
          pulsing: true,
          iconColor: AppTheme.tertiaryContainer,
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String agentName;
  final String timeAgo;
  final String title;
  final String description;
  final Color leftBorderColor;
  final String badgeLabel;
  final Color badgeBg;
  final bool pulsing;
  final Color iconColor;

  const _ActionCard({
    required this.agentName,
    required this.timeAgo,
    required this.title,
    required this.description,
    required this.leftBorderColor,
    required this.badgeLabel,
    required this.badgeBg,
    required this.pulsing,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // ClipRRect + Stack: uniform border on card, Positioned left accent bar.
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              border: Border.all(color: const Color(0xFF1F2937)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.smart_toy, color: iconColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          agentName,
                          style: GoogleFonts.jetBrainsMono(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      timeAgo,
                      style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppTheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (pulsing) ...[
                        _PulseDot(color: badgeBg),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        badgeLabel,
                        style: GoogleFonts.jetBrainsMono(
                          color: badgeBg,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 4px left accent bar
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(width: 4, color: leftBorderColor),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pulsing dot widget
// ─────────────────────────────────────────────────────────────────────────────

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 24hr Forecast Sparkline Card
// ─────────────────────────────────────────────────────────────────────────────

class _ForecastCard extends StatelessWidget {
  const _ForecastCard();

  static const _bars = [
    _BarData(height: 1.00, color: AppTheme.error),
    _BarData(height: 0.95, color: AppTheme.error),
    _BarData(height: 0.90, color: AppTheme.error),
    _BarData(height: 0.75, color: AppTheme.tertiaryContainer),
    _BarData(height: 0.70, color: AppTheme.tertiaryContainer),
    _BarData(height: 0.65, color: AppTheme.tertiaryContainer),
    _BarData(height: 0.60, color: AppTheme.tertiaryContainer),
    _BarData(height: 0.60, color: AppTheme.tertiaryContainer),
    _BarData(height: 0.45, color: AppTheme.primaryContainer),
    _BarData(height: 0.40, color: AppTheme.primaryContainer),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '24hr AQI Forecast',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                'Trend: Improving',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _bars.map((bar) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    height: 64 * bar.height,
                    decoration: BoxDecoration(
                      color: bar.color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(3),
                        topRight: Radius.circular(3),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppTheme.outlineVariant),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Now (623)',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '+24h (398)',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final double height;
  final Color color;
  const _BarData({required this.height, required this.color});
}
