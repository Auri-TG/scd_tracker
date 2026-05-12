import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatefulWidget {
  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  String range = "month";

  List<DateTime> generateDates(DateTime start, DateTime end) {
    List<DateTime> days = [];
    for (DateTime d = start;
        d.isBefore(end.add(Duration(days: 1)));
        d = d.add(Duration(days: 1))) {
      days.add(d);
    }
    return days;
  }

  Map<DateTime, int?> buildData() {
    final box = Hive.box('entries');
    Map<DateTime, int?> data = {};

    DateTime now = DateTime.now();
    DateTime start;

    if (range == "week") {
      start = now.subtract(Duration(days: 7));
    } else if (range == "year") {
      start = now.subtract(Duration(days: 365));
    } else {
      start = now.subtract(Duration(days: 30));
    }

    List<DateTime> days = generateDates(start, now);

    for (var d in days) {
      String key = DateFormat('yyyy-MM-dd').format(d);
      data[d] = box.get(key); // null if missing
    }

    return data;
  }

  List<LineChartBarData> buildLines(Map<DateTime, int?> data) {
  List<FlSpot> currentSegment = [];
  List<LineChartBarData> lines = [];

  int i = 0;

  data.forEach((date, value) {
    if (value != null) {
      currentSegment.add(
        FlSpot(i.toDouble(), value.toDouble()),
      );
    } else {
      if (currentSegment.isNotEmpty) {
        lines.add(LineChartBarData(
          spots: List.from(currentSegment),
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          dotData: FlDotData(show: true),
        ));
        currentSegment.clear();
      }
    }
    i++;
  });

  // Add last segment
  if (currentSegment.isNotEmpty) {
    lines.add(LineChartBarData(
      spots: currentSegment,
      isCurved: true,
      color: Colors.green,
      barWidth: 3,
      dotData: FlDotData(show: true),
    ));
  }

  return lines;
  }

  @override
  Widget build(BuildContext context) {
    final data = buildData();

    return Scaffold(
      appBar: AppBar(title: Text("Your SCD Graph")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(onPressed: () => setState(() => range = "week"), child: Text("Semana")),
              TextButton(onPressed: () => setState(() => range = "month"), child: Text("Mes")),
              TextButton(onPressed: () => setState(() => range = "year"), child: Text("Ano")),
            ],
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 100,
                  lineBarsData: buildLines(data),

                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
