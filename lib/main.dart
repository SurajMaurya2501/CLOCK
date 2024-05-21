import 'package:alarm/alarm.dart';
import 'package:alarm_clock/screen/home.dart';
import 'package:alarm_clock/screen/ring_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: false);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Alarm.ringStream.stream.listen(
      (_) async {
        goToAlarmPage();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }

  Future goToAlarmPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RingScreen(),
      ),
    );
  }
}
