import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double value = 50;

  String todayKey() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  bool isLocked() {
    final box = Hive.box('entries');
    return box.get(todayKey()) != null;
  }

  void save() {
    final box = Hive.box('entries');
    final settings = Hive.box('settings');

    bool allowEdit = settings.get("allowEdit", defaultValue: false);

    String key = todayKey();

    if (box.get(key) != null && !allowEdit) {
      return; // Locked
    }

    box.put(key, value.toInt());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool locked = isLocked();

    return Scaffold(
      appBar: AppBar(title: Text("Scd Tracker")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("How ... are you today?", style: TextStyle(fontSize: 20)),

          SizedBox(height: 30),

          Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: locked ? null : (v) => setState(() => value = v),
          ),

          Text(value.toInt().toString()),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: locked ? null : save,
            child: Text(locked ? "Already saved today" : "Save"),
          ),
        ],
      ),
    );
  }
}