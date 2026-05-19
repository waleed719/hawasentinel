import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  // Simulated 24-hour AQI forecast data
  static const _forecastSpots = [
    FlSpot(0, 623),
    FlSpot(3, 668),
    FlSpot(6, 700),
    FlSpot(9, 645),
    FlSpot(12, 589),
    FlSpot(15, 540),
    FlSpot(18, 512),
    FlSpot(21, 470),
    FlSpot(24, 437),
  ];

  static const _factors = [
    _Factor(
      'Stubble Burning',
      'Very High',
      AppTheme.error,
      0.95,
      Icons.local_fire_department_outlined,
    ),
    _Factor(
      'Wind Speed',
      '1.2 m/s',
      AppTheme.onSurfaceVariant,
      0.15,
      Icons.air_outlined,
    ),
    _Factor(
      'Humidity',
      '72%',
      AppTheme.secondary,
      0.72,
      Icons.water_drop_outlined,
    ),
    _Factor(
      'Temperature',
      '26°C',
      AppTheme.onSurfaceVariant,
      0.45,
      Icons.thermostat_outlined,
    ),
    _Factor(
      'Vehicle Emission',
      'High',
      AppTheme.tertiary,
      0.78,
      Icons.directions_car_outlined,
    ),
    _Factor(
      'Industrial Dust',
      'Moderate',
      Color(0xFFFFA858),
      0.55,
      Icons.factory_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                  'Analytics & Forecast',
                  style: GoogleFonts.inter(
                    color: AppTheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'NEXT 24-HOUR OUTLOOK',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.primary,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildForecastCard(),
                const SizedBox(height: 20),
                _buildAqiStatsRow(),
                const SizedBox(height: 20),
                _buildFactorsCard(),
                const SizedBox(height: 20),
                _buildAqiLegendCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AQI Forecast',
                style: GoogleFonts.inter(
                  color: AppTheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'HAZARDOUS',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.error,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Projected to remain elevated through 06:00',
            style: GoogleFonts.inter(
              color: AppTheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppTheme.outlineVariant.withValues(alpha: 0.5),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: 200,
                      getTitlesWidget: (v, _) => Text(
                        v.toInt().toString(),
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 6,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}h',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 24,
                minY: 0,
                maxY: 800,
                lineBarsData: [
                  LineChartBarData(
                    spots: _forecastSpots,
                    isCurved: true,
                    color: AppTheme.error,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                        radius: 3,
                        color: AppTheme.error,
                        strokeWidth: 1.5,
                        strokeColor: AppTheme.surfaceContainer,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.error.withValues(alpha: 0.3),
                          AppTheme.error.withValues(alpha: 0.0),
                        ],
                      ),
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

  Widget _buildAqiStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Current',
            value: '623',
            color: AppTheme.error,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Peak (6h)',
            value: '700',
            color: AppTheme.error,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Forecast (24h)',
            value: '437',
            color: AppTheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildFactorsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contributing Factors',
            style: GoogleFonts.inter(
              color: AppTheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Real-time pollution source analysis',
            style: GoogleFonts.inter(
              color: AppTheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ..._factors.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _FactorRow(factor: f),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAqiLegendCard() {
    const levels = [
      _AqiLevel('Good', '0–50', Color(0xFF46F1C5)),
      _AqiLevel('Moderate', '51–100', Color(0xFFFFCEA6)),
      _AqiLevel('Unhealthy (Sensitive)', '101–150', Color(0xFFFFA858)),
      _AqiLevel('Unhealthy', '151–200', Color(0xFFFF6B6B)),
      _AqiLevel('Very Unhealthy', '201–300', Color(0xFFD2BBFF)),
      _AqiLevel('Hazardous', '301+', AppTheme.error),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AQI Scale Reference',
            style: GoogleFonts.inter(
              color: AppTheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...levels.map(
            (l) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: l.color,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: l.color.withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.label,
                      style: GoogleFonts.inter(
                        color: AppTheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    l.range,
                    style: GoogleFonts.jetBrainsMono(
                      color: l.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

// ── Small widgets ────────────────────────────────────────────────────────────

class _Factor {
  final String label;
  final String value;
  final Color color;
  final double intensity; // 0.0 – 1.0
  final IconData icon;

  const _Factor(this.label, this.value, this.color, this.intensity, this.icon);
}

class _FactorRow extends StatelessWidget {
  final _Factor factor;
  const _FactorRow({required this.factor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(factor.icon, size: 14, color: factor.color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                factor.label,
                style: GoogleFonts.inter(
                  color: AppTheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              factor.value,
              style: GoogleFonts.jetBrainsMono(
                color: factor.color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: factor.intensity,
            backgroundColor: factor.color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(factor.color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AqiLevel {
  final String label;
  final String range;
  final Color color;
  const _AqiLevel(this.label, this.range, this.color);
}
