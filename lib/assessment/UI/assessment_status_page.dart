import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AssessmentStatusPage extends StatelessWidget {
  const AssessmentStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assessment Status',
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Weekly Assessment Overview',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AssessmentChart(), // Display the bar chart
            ),
          ],
        ),
      ),
    );
  }
}

class AssessmentChart extends StatelessWidget {
  const AssessmentChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('assessments').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var assessmentData = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        var weeklyData = _getWeeklyData(assessmentData);

        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: _buildBarGroups(weeklyData),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Low');
                      case 1:
                        return const Text('Medium');
                      case 2:
                        return const Text('High');
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun'
                    ];
                    return Text(days[value.toInt()]);
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: false),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, int> weeklyData) {
    return weeklyData.entries.map((entry) {
      return BarChartGroupData(
        x: _getWeekdayIndex(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble() / 10, // Normalized for Low/Medium/High
            color: Colors.blue,
          ),
        ],
      );
    }).toList();
  }

  int _getWeekdayIndex(String weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays.indexOf(weekday);
  }

  Map<String, int> _getWeeklyData(List<Map<String, dynamic>> data) {
    Map<String, int> weeklyData = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    for (var assessment in data) {
      DateTime date = (assessment['date'] as Timestamp).toDate();
      String weekday = _getWeekdayString(date.weekday);
      weeklyData[weekday] = (weeklyData[weekday] ?? 0) + 1;
    }

    return weeklyData;
  }

  String _getWeekdayString(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}
