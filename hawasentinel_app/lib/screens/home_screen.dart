import 'package:flutter/material.dart';
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
                  const _MiniStatRow(),
                  const SizedBox(height: 24),
                  _AgentActionsSection(sim: sim),
                  const SizedBox(height: 24),
                  const _ForecastCard(),
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
            onTap: isLoading ? null : () => appState.triggerSimulation('hazardous'),
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
                    color: isLoading ? AppTheme.onSurfaceVariant : AppTheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Fast Replay',
                    style: GoogleFonts.inter(
                      color: isLoading ? AppTheme.onSurfaceVariant : AppTheme.primary,
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
                        border: Border.all(color: AppTheme.background, width: 1.5),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF690005), Color(0xFF3A0002)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorContainer, width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background watermark icon
          Positioned(
            right: -16,
            bottom: -16,
            child: Icon(
              Icons.masks_outlined,
              size: 180,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CURRENT AQI',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            size: 13,
                            color: AppTheme.onPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            crisisLevel.toUpperCase(),
                            style: GoogleFonts.jetBrainsMono(
                              color: AppTheme.onPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isLoading ? '--' : '$aqi',
                      style: GoogleFonts.inter(
                        color: AppTheme.error,
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'PM2.5: 287 μg/m³',
                        style: GoogleFonts.inter(
                          color: AppTheme.errorContainer,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: AppTheme.errorContainer.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.thermostat,
                      size: 16,
                      color: AppTheme.errorContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Feels like 48°C',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.errorContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppTheme.errorContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.water_drop_outlined,
                      size: 16,
                      color: AppTheme.errorContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Humidity 72%',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.errorContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mini Stat Row
// ─────────────────────────────────────────────────────────────────────────────

class _MiniStatRow extends StatelessWidget {
  const _MiniStatRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.air,
            iconColor: AppTheme.primaryContainer,
            label: 'Wind',
            value: 'NE 14 km/h',
            accentBottom: false,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            iconColor: AppTheme.tertiaryContainer,
            label: 'Fires',
            value: '23 Active',
            accentBottom: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.visibility,
            iconColor: AppTheme.onSurfaceVariant,
            label: 'Visibility',
            value: '0.8 km',
            accentBottom: false,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool accentBottom;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.accentBottom,
  });

  @override
  Widget build(BuildContext context) {
    // ClipRRect so the bottom accent respects rounded corners.
    // Border.all (uniform) avoids the non-uniform-color + borderRadius crash.
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              border: Border.all(color: const Color(0xFF1F2937)),
            ),
            child: Column(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: AppTheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (accentBottom)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(height: 3, color: AppTheme.tertiaryContainer),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
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
