import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm_clock/screen/ring_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime selectedDateTime;
  bool loading = false;
  final title = TextEditingController();
  final description = TextEditingController();
  bool isAlarmSet = false;

  @override
  void initState() {
    selectedDateTime = DateTime.now().add(
      const Duration(
        minutes: 1,
      ),
    );
    selectedDateTime = selectedDateTime.copyWith(
      second: 0,
      millisecond: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 23, 23, 23),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.alarm,
                color: Colors.white,
                size: 150,
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: title,
                  decoration: const InputDecoration(
                    hintText: "Title for alarm",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: description,
                  decoration: const InputDecoration(
                    hintText: "Description for alarm",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: pickTime,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Text(
                        TimeOfDay.fromDateTime(
                          selectedDateTime,
                        ).format(context),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    onTap: saveAlarm,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              isAlarmSet
                  ? const Text(
                      "✔️Alarm set Successfully!",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  AlarmSettings buildAlarmSettings() {
    final id = DateTime.now().millisecondsSinceEpoch % 10000;

    final alarmSettings = AlarmSettings(
      id: id,
      stopOnNotificationOpen: true,
      enableNotificationOnKill: true,
      fadeDuration: 5.0,
      volumeMax: false,
      dateTime: selectedDateTime,
      loopAudio: true,
      vibrate: true,
      assetAudioPath: "assets/iphone-2560.mp3",
      notificationTitle: title.text.isEmpty ? "Alarm" : title.text,
      notificationBody:
          description.text.isEmpty ? "Description" : description.text,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      setState(() => loading = false);
      isAlarmSet = true;
    });
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final DateTime now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }
}
