import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../models/category_accuracy_model.dart';
import '../models/note_accuracy_model.dart';
import '../providers/quiz_session_provider.dart';
import '../providers/statistics_provider.dart';
import '../models/statistics_model.dart';
import '../reusable_widgets/reusable_widgets.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedChartIndex = 0;
  List<bool> _selected = [true, false, false];

  void _onToggle(int index) {
    setState(() {
      for (int i = 0; i < _selected.length; i++) {
        _selected[i] = i == index;
      }
      _selectedChartIndex = index;
    });
  }

  Widget _buildCategoryProgress(StatisticsModel stats) {
    final statsList = stats.categoryAccuracy;

    if (statsList.isEmpty) {
      return const Text('No category data');
    }

    final totalAttempts = statsList.fold<int>(0, (sum, item) => sum + item.attempts);
    if (totalAttempts == 0) {
      return const Text('No attempts recorded');
    }

    // Calculate weighted total accuracy (weighted by attempts)
    double weightedAccuracySum = 0;
    for (var cat in statsList) {
      weightedAccuracySum += cat.accuracy * cat.attempts;
    }
    final totalAccuracy = weightedAccuracySum / totalAttempts;

    final categoryColors = [
      Colors.blue,
      Colors.lime,
      Colors.red,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.brown,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
    ];

    // Map your categories to descriptive names here
    final categoryNames = {
      'general': 'General Category',
      'interval_training': 'Interval Training',
      'note_training': 'Note Training',
      // add other keys as needed
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(220, 220),
                painter: _CategoryCircularProgressPainter(
                  categories: statsList,
                  colors: categoryColors,
                  totalAttempts: totalAttempts,
                ),
              ),
              // Center total accuracy text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${totalAccuracy.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Total Accuracy",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0D47A1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Vertical list of cards full width
        Column(
          children: statsList.map((data) {
            final i = statsList.indexOf(data);
            final percent = totalAttempts == 0 ? 0 : (data.attempts / totalAttempts) * 100;

            final displayName = categoryNames[data.category.toLowerCase()] ?? data.category;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Row(
                      children: [
                        // Left side: Color circle + Category + Attempts + Accuracy
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: categoryColors[i % categoryColors.length],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Attempts: ${data.attempts}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Accuracy: ${data.accuracy.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side: Time percentage + progress bar
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.only(top: 45), // adjust bottom padding to move content up/down
                            alignment: Alignment.bottomRight, // align everything to bottom right
                            child: Column(
                              mainAxisSize: MainAxisSize.min,  // only as big as content inside the container
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Time %: ${percent.toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: percent / 100,
                                    color: categoryColors[i % categoryColors.length],
                                    backgroundColor: Colors.grey.shade400,
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChart(StatisticsModel stats) {

    switch (_selectedChartIndex) {
      case 0:
        return _buildCategoryProgress(stats);

      case 1:
        final accuracyList = stats.recentAccuracy;
        if (accuracyList == null || accuracyList.isEmpty) {
          return const Text('No recent accuracy data');
        }

        return SizedBox(
          height: 350,
          width: double.infinity,
          child: CustomPaint(
            painter: _RecentAccuracyLinePainter(accuracyList),
          ),
        );

    case 2:
      final strongAreas = stats.strongAreas ?? [];
      final weakAreas = stats.weakAreas ?? [];
      if (strongAreas.isEmpty && weakAreas.isEmpty) {
        return const Center(child: Text('No note accuracy data'));
      }
      return SizedBox(
        height: 350,
        width: double.infinity,
        child: NoteAccuracyBarChart(
          strongAreas: strongAreas,
          weakAreas: weakAreas,
        ),
      );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<StatisticsProvider>(context);
    final stats = statsProvider.statistics;

    if (stats == null || stats.categoryAccuracy.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Statistics",
            style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF0D47A1)),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_objects, size: 80, color: Colors.orangeAccent),
                const SizedBox(height: 24),
                const Text(
                  'No Stats Yet!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your stats are sleeping 😴\nWake them up by attempting a quiz!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: "Start Quiz",
                  onTap: () async {
                    await Provider.of<QuizSessionProvider>(
                      context,
                      listen: false,
                    ).startSession("general", 10);

                    Navigator.pushNamed(context, '/quiz_screen');
                  },
                  color: const Color(0xFFCDDC39),
                  icon: Icons.play_circle_outline,
                ),
              ],
            ),
          ),
        ),

      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Your Profile",
          style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0D47A1)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          children: [
            // ToggleButtons with bigger horizontal size and blue highlight
            ToggleButtons(
              borderRadius: BorderRadius.circular(12),
              isSelected: _selected,
              onPressed: _onToggle,
              fillColor: Colors.blue.shade100,
              selectedColor: Colors.blue.shade900,
              color: Colors.black87,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              constraints: const BoxConstraints(
                minHeight: 48,
                minWidth: 110,
              ),
              children: const [
                Text("Overall", style: TextStyle(fontSize: 14, color: Color(0xFF0D47A1)),),
                Text("Recent", style: TextStyle(fontSize: 14, color: Color(0xFF0D47A1)),),
                Text("Note", style: TextStyle(fontSize: 14, color: Color(0xFF0D47A1)),),
              ],
            ),

            const SizedBox(height: 30),

            // Scrollable chart + cards
            Expanded(
              child: SingleChildScrollView(
                child: Center(child: _buildChart(stats)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ==========================================
// ------------ Category Accuracy -----------

class _CategoryCircularProgressPainter extends CustomPainter {
  final List<CategoryAccuracy> categories;
  final List<Color> colors;
  final int totalAttempts;

  _CategoryCircularProgressPainter({
    required this.categories,
    required this.colors,
    required this.totalAttempts,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 24.0;
    final radius = (size.width / 2) - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final paintBackground = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw full grey background circle
    canvas.drawCircle(center, radius, paintBackground);

    double startAngle = -pi / 2; // start at top (12 o'clock)

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final sweepAngle = (category.attempts / totalAttempts) * 2 * pi;

      final paintArc = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paintArc,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ====================================
// ====================================
// ----------- Recent Accuracy --------

class RecentAccuracyChart extends StatelessWidget {
  final List<double> dataPoints;

  const RecentAccuracyChart({super.key, required this.dataPoints});

  Widget _buildLegendCard(Color color, String label, String range) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              Text(
                range,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title above the chart
            const Center(
              child: Text(
                'Last 10 Quizzes Attempted',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Chart
            AspectRatio(
              aspectRatio: 1.7,
              child: CustomPaint(
                painter: _RecentAccuracyLinePainter(dataPoints),
              ),
            ),

            const SizedBox(height: 16),

            // Description text below chart
            const Text(
              'This chart shows your quiz accuracy over the last 10 quizzes. '
                  'Accuracy below 60% is considered poor, 60%-80% good, and above 80% very good.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 24),

            // Accuracy zones title
            const Text(
              'Accuracy Zones:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // Legend cards
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildLegendCard(Colors.red, 'Poor', '0% - 60%'),
                _buildLegendCard(Colors.orange, 'Good', '60% - 80%'),
                _buildLegendCard(Colors.green, 'Very Good', '80% - 100%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


  class _RecentAccuracyLinePainter extends CustomPainter {
  final List<double> dataPoints;
  _RecentAccuracyLinePainter(this.dataPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final double maxY = 100;
    final double minY = 0;
    final double paddingLeft = 40;
    final double paddingBottom = 70;
    final double paddingTop = 50;
    final double paddingRight = 20;

    final double chartHeight = size.height - paddingTop - paddingBottom;
    final double chartWidth = size.width - paddingLeft - paddingRight;

    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final zones = [
      {'start': 80, 'end': 100, 'color': Colors.green},
      {'start': 60, 'end': 80, 'color': Colors.orange},
      {'start': 0, 'end': 60, 'color': Colors.red},
    ];

    for (var zone in zones) {
      final double startY = paddingTop +
          ((maxY - (zone['end'] as num)) / (maxY - minY)) * chartHeight;
      final double endY = paddingTop +
          ((maxY - (zone['start'] as num)) / (maxY - minY)) * chartHeight;
      final Rect rect =
      Rect.fromLTRB(paddingLeft, startY, paddingLeft + chartWidth, endY);
      final Paint zonePaint =
      Paint()..color = (zone['color'] as Color).withOpacity(0.15);
      canvas.drawRect(rect, zonePaint);
    }

    final int divisions = 5;
    final TextPainter textPainter =
    TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= divisions; i++) {
      final yValue = (i * 100 ~/ divisions);
      final y = paddingTop + ((maxY - yValue) / (maxY - minY)) * chartHeight;

      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(paddingLeft + chartWidth, y),
        Paint()
          ..color = Colors.grey.shade300
          ..strokeWidth = 1,
      );

      textPainter.text = TextSpan(
        text: '$yValue%',
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(paddingLeft - textPainter.width - 6, y - 6));
    }

    final Path path = Path();
    final double spacing = chartWidth / (dataPoints.length - 1);

    for (int i = 0; i < dataPoints.length; i++) {
      final double x = paddingLeft + spacing * i;
      final double y =
          paddingTop + ((maxY - dataPoints[i]) / (maxY - minY)) * chartHeight;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, pointPaint);

      final TextPainter labelPainter = TextPainter(
        text: TextSpan(
          text: 'Q${i + 1}',
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(
          canvas, Offset(x - labelPainter.width / 2, paddingTop + chartHeight + 4));
    }

    canvas.drawPath(path, linePaint);

    final TextPainter titlePainter = TextPainter(
      text: const TextSpan(
        text: 'Accuracy',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(canvas, Offset(paddingLeft, paddingTop - 40));

    final TextPainter subtitlePainter = TextPainter(
      text: const TextSpan(
        text: 'Last 10 Quizzes Attempted',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
      ),
      textDirection: TextDirection.ltr,
    );
    subtitlePainter.layout();
    subtitlePainter.paint(
      canvas,
      Offset(paddingLeft + chartWidth / 2 - subtitlePainter.width / 2, paddingTop + chartHeight + 28),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


// ======================================
// ======================================
// ------------ Note Accuracy -----------

class NoteAccuracyBarChart extends StatelessWidget {
  final List<NoteAccuracy> strongAreas;
  final List<NoteAccuracy> weakAreas;

  const NoteAccuracyBarChart({
    Key? key,
    required this.strongAreas,
    required this.weakAreas,
  }) : super(key: key);

  Color _getColorForAccuracy(double accuracy) {
    if (accuracy >= 80) {
      return Colors.green;
    } else if (accuracy >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allNotes = [
      ...strongAreas.map((e) => e.note),
      ...weakAreas.map((e) => e.note),
    ];

    final allAreas = [...strongAreas, ...weakAreas];

    final allGroups = List.generate(allAreas.length, (index) {
      final accuracy = allAreas[index].accuracy;
      final color = _getColorForAccuracy(accuracy);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: accuracy,
            color: color,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    Widget _buildLegendCard(Color color, String label) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color.darken(0.2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              maxY: 100,
              minY: 0,
              groupsSpace: 12,
              barGroups: allGroups,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= allNotes.length) return Container();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(allNotes[index]),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 20,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text('${value.toInt()}%');
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true, horizontalInterval: 20),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),

        const Text(
          'Accuracy of the notes',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        const SizedBox(height: 20),
        // Legend cards row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendCard(Colors.red, 'Poor: 0 - 60%'),
              _buildLegendCard(Colors.orange, 'Good 60 - 80%'),
              _buildLegendCard(Colors.green, 'Very Good 80 - 100%'),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Description below the legend

      ],
    );
  }
}

// Extension method to darken a color
extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
