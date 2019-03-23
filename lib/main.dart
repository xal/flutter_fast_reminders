// This sample shows creation of a [Card] widget that can be tapped. When
// tapped this [Card]'s [InkWell] displays an "ink splash" that fills the
// entire card.

import 'package:fastreminders/reminder_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'reminder_root_widget.dart';

var reminderBuilder;

void main() {
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(new InitializationSettings(
      new AndroidInitializationSettings('ic_access_alarm_black_24dp'),
      new IOSInitializationSettings()));

  reminderBuilder = new ReminderBuilder(flutterLocalNotificationsPlugin);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast reminders',
      home: AddToDoPage(reminderBuilder),
    );
  }
}
