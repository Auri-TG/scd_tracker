import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home.dart';
import 'graph.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('entries');
  await Hive.openBox('settings');
  runApp(MyApp());
}

class HomeWrapper extends StatefulWidget {
  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int index = 0;

  final pages = [
    HomePage(),
    GraphPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Graph"),
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = Hive.box('settings');

  @override
  Widget build(BuildContext context) {
    bool dark = box.get("darkMode", defaultValue: false);

    return MaterialApp(
      title: 'SCD Tracker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: HomeWrapper(),
    );
  }
}
