import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderBuilder {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ReminderBuilder(this.flutterLocalNotificationsPlugin);

  String who;
  String what;
  DateTime when;
  int counter;

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future scheduleNotification() async {
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Reminder',
        what + ' ' + who,
        when,
        new NotificationDetails(
            new AndroidNotificationDetails(
              'fast_reminders_channel_id',
              'Fast reminders',
              'Reminder notifications',
//              sound: 'slow_spring_board',
            ),
            new IOSNotificationDetails(sound: "slow_spring_board.aiff")));
  }
}
