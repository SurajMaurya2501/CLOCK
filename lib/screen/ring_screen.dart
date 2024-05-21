import 'package:alarm_clock/screen/home.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class RingScreen extends StatefulWidget {
  const RingScreen({super.key});

  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen> {
  final player = AudioPlayer();

  @override
  void initState() {
    playAlarm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                player.stop().whenComplete(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                });
              },
              child: const Text(
                "Stop",
              ),
            ),
          )
        ],
      )),
    );
  }

  Future playAlarm() async {
    await player.play(volume: 1.0, AssetSource('iphone-2560.mp3'));
  }
}
