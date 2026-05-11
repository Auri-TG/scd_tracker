import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final box = Hive.box('settings');

  bool get darkMode => box.get("darkMode", defaultValue: false);
  bool get allowEdit => box.get("allowEdit", defaultValue: false);

  void toggleDark(bool value) {
    box.put("darkMode", value);
    setState(() {});
  }

  void toggleEdit(bool value) {
    box.put("allowEdit", value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          SwitchListTile(
            title: Text("Dark Mode"),
            value: darkMode,
            onChanged: toggleDark,
          ),

          SwitchListTile(
            title: Text("Allow editing past entries"),
            value: allowEdit,
            onChanged: toggleEdit,
          ),
        ],
      ),
    );
  }
}