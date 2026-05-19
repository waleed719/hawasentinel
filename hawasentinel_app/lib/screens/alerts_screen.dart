import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final sim = appState.currentSimulation;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.background,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Alerts Center',
                  style: GoogleFonts.inter(
                    color: AppTheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'CRISIS NOTIFICATIONS',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.error,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (sim == null)
            const SliverFillRemaining(child: _NoAlertsState(hasRun: false))
          else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              sliver: SliverToBoxAdapter(child: _AlertSummaryBanner(sim: sim)),
            ),
            _buildAlertsList(sim),
          ],
        ],
      ),
    );
  }

  Widget _buildAlertsList(dynamic sim) {
    final alerts = <_AlertData>[];

    if (sim.agents.school.rawData['notice'] != null) {
      alerts.add(
        _AlertData(
          title: 'School Closure Advisory',
          subtitle:
              sim.agents.school.rawData['notice']['english'] ??
              'School safety advisory active.',
          icon: Icons.school_outlined,
          severity: AlertSeverity.critical,
          source: 'School Safety Agent',
          time: 'Just now',
        ),
      );
    }

    if (sim.agents.hospital.rawData['reallocation'] != null) {
      final beds = sim.agents.hospital.rawData['reallocation']['beds_added'];
      alerts.add(
        _AlertData(
          title: 'Hospital Preparedness Protocol',
          subtitle:
              '$beds emergency beds added. Nebulizers and respiratory equipment ordered.',
          icon: Icons.local_hospital_outlined,
          severity: AlertSeverity.warning,
          source: 'Hospital Triage Agent',
          time: '1 min ago',
        ),
      );
    }

    if (sim.agents.rider.rawData['routing'] != null) {
      final avoid = (sim.agents.rider.rawData['routing']['avoid_zones'] as List)
          .join(', ');
      alerts.add(
        _AlertData(
          title: 'Gig Worker Route Advisory',
          subtitle:
              'High AQI detected. Avoid exposure zones: $avoid. Use N95 mask.',
          icon: Icons.alt_route_outlined,
          severity: AlertSeverity.info,
          source: 'Gig Worker Agent',
          time: '2 min ago',
        ),
      );
    }

    if (alerts.isEmpty) {
      return const SliverFillRemaining(child: _NoAlertsState(hasRun: true));
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AlertCard(data: alerts[i]),
          ),
          childCount: alerts.length,
        ),
      ),
    );
  }
}

enum AlertSeverity { critical, warning, info }

class _AlertData {
  final String title;
  final String subtitle;
  final IconData icon;
  final AlertSeverity severity;
  final String source;
  final String time;

  const _AlertData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.severity,
    required this.source,
    required this.time,
  });

  Color get color {
    switch (severity) {
      case AlertSeverity.critical:
        return AppTheme.error;
      case AlertSeverity.warning:
        return AppTheme.tertiary;
      case AlertSeverity.info:
        return AppTheme.secondary;
    }
  }

  String get severityLabel {
    switch (severity) {
      case AlertSeverity.critical:
        return 'CRITICAL';
      case AlertSeverity.warning:
        return 'WARNING';
      case AlertSeverity.info:
        return 'INFO';
    }
  }
}

class _AlertSummaryBanner extends StatelessWidget {
  final dynamic sim;
  const _AlertSummaryBanner({required this.sim});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.errorContainer.withValues(alpha: 0.6),
            AppTheme.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.crisis_alert_rounded,
              color: AppTheme.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crisis Level: ${sim.crisisLevel ?? 'ACTIVE'}',
                  style: GoogleFonts.inter(
                    color: AppTheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'AI agents are monitoring and responding.',
                  style: GoogleFonts.inter(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 12,
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

class _AlertCard extends StatelessWidget {
  final _AlertData data;
  const _AlertCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: data.color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.title,
                              style: GoogleFonts.inter(
                                color: AppTheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: data.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: data.color.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              data.severityLabel,
                              style: GoogleFonts.jetBrainsMono(
                                color: data.color,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.subtitle,
                        style: GoogleFonts.inter(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.smart_toy_outlined,
                  color: AppTheme.onSurfaceVariant,
                  size: 13,
                ),
                const SizedBox(width: 6),
                Text(
                  data.source,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                Text(
                  data.time,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 11,
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

class _NoAlertsState extends StatelessWidget {
  final bool hasRun;
  const _NoAlertsState({required this.hasRun});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 36,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasRun ? 'No Active Alerts' : 'System Idle',
            style: GoogleFonts.inter(
              color: AppTheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasRun
                ? 'All agents report normal conditions.'
                : 'Run a simulation from the Home tab.',
            style: GoogleFonts.inter(
              color: AppTheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
