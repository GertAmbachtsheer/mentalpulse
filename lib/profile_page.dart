import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/mood_service.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final MoodService _moodService = MoodService();
  User? _user;
  List<Map<String, dynamic>> _moodHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchMoodHistory();
  }

  Future<void> _fetchMoodHistory() async {
    if (_user == null) return;
    try {
      final history = await _moodService.getMoodHistory(_user!.uid);
      setState(() {
        _moodHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching mood history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  final List<String> _moodLabels = ['Great', 'Good', 'Okay', 'Bad', 'Terrible'];
  final List<Color> _moodColors = [
    Colors.green,
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile & Insights',
          style: TextStyle(
            color: Color(0xFF1E3A8A),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A8A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfoCard(),
                  const SizedBox(height: 32),
                  const Text(
                    'Mood Journey (Past 14 Days)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMoodGraphCard(),
                  const SizedBox(height: 32),
                  _buildMoodLegend(),
                ],
              ),
            ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 300) {
            return Column(
              children: [
                _buildAvatar(),
                const SizedBox(height: 16),
                _buildDetails(),
              ],
            );
          }
          return Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 20),
              Expanded(child: _buildDetails()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: const Color(0xFFDBEAFE),
      child: Text(
        _user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E3A8A),
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _user?.displayName ?? 'User',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        Text(
          _user?.email ?? '',
          style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildMoodGraphCard() {
    return Container(
      height: 300,
      padding: const EdgeInsets.fromLTRB(16, 32, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _moodHistory.isEmpty
          ? const Center(
              child: Text(
                'No mood data for the last 14 days.\nStart tracking today!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            )
          : LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= _moodHistory.length) {
                          return const SizedBox.shrink();
                        }
                        // Only show labels for some points to avoid crowding
                        if (_moodHistory.length > 7 && index % 2 != 0) {
                          return const SizedBox.shrink();
                        }
                        String dateStr = _moodHistory[index]['date'];
                        DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= _moodLabels.length) {
                          return const SizedBox.shrink();
                        }
                        // 0 is Great, 4 is Terrible.
                        // We want Great at top (4 on chart axis) and Terrible at bottom (0 on chart axis)
                        // But _moodLabels[0] is Great.
                        // So graphValue = 4 - moodIndex.
                        // If index = 4 (Great), label is _moodLabels[0]
                        return Text(
                          _moodLabels[4 - index],
                          style: TextStyle(
                            color: _moodColors[4 - index],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (_moodHistory.length - 1).toDouble(),
                minY: 0,
                maxY: 4,
                lineBarsData: [
                  LineChartBarData(
                    spots: _moodHistory.asMap().entries.map((entry) {
                      int idx = entry.key;
                      int moodIdx = entry.value['moodIndex'];
                      // Invert for better visualization: Great (0) -> 4, Terrible (4) -> 0
                      return FlSpot(idx.toDouble(), (4 - moodIdx).toDouble());
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF1E3A8A),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF1E3A8A).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMoodLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(_moodLabels.length, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _moodColors[index],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _moodLabels[index],
              style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
            ),
          ],
        );
      }),
    );
  }
}
