// This sample shows creation of a [Card] widget that can be tapped. When
// tapped this [Card]'s [InkWell] displays an "ink splash" that fills the
// entire card.

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

ReminderBuilder reminderBuilder;
ReminderWidget whoWidget;
ReminderWidget whatWidget;
ReminderWidget whenWidget;

var textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

typedef void onTextTapFunc(BuildContext context, String text);
typedef void onDateTapFunc(BuildContext context, DateTime date);

void whatCallback(BuildContext context, String text) {
  reminderBuilder.what = text;
  moveTo(context, whoWidget);
}

void whoCallback(BuildContext context, String text) {
  reminderBuilder.who = text;
  moveTo(context, whenWidget);
}

void moveTo(BuildContext context, ReminderWidget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void dateCallback(BuildContext context, DateTime date) {
  reminderBuilder.when = date;
  var message = reminderBuilder.createMessage();
  reminderBuilder.scheduleNotification(message);

  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text("Scheduled: " + message),
    duration: new Duration(seconds: 3),
  ));

//  Navigator.popUntil(context, (route) => route.isFirst);
}

void main() {

  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(new InitializationSettings(
      new AndroidInitializationSettings('ic_access_alarm_black_24dp'),
      new IOSInitializationSettings()));

  reminderBuilder = new ReminderBuilder(flutterLocalNotificationsPlugin);

  whatWidget = ReminderWidget(
    "Reminder about...",
    [
      whatTile(Colors.pink, Icons.add, "Something"),
      whatTile(Colors.lightBlue, Icons.add_shopping_cart, "Buy"),
      whatTile(Colors.lightBlue, Icons.call, "Call"),
      whatTile(Colors.lightBlue, Icons.message, "Message"),
      whatTile(Colors.lightBlue, Icons.monetization_on, "Debt"),
      whatTile(Colors.lightBlue, Icons.monetization_on, "Pay"),
      whatTile(Colors.lightBlue, Icons.help, "Help"),
      whatTile(Colors.lightBlue, Icons.help, "Give"),
      whatTile(Colors.lightBlue, Icons.help, "Get"),
      whatTile(Colors.lightBlue, Icons.place, "Meet"),
      whatTile(Colors.lightBlue, Icons.place, "Deadline"),
      whatTile(Colors.lightBlue, Icons.place, "Check"),
    ],
  );
  whoWidget = ReminderWidget(
    "Related to...",
    [
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Someone"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Me"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Partner"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Family"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Friend"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Work"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Client"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Boss"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Health"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Car"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Home"),
      whoTile(Colors.pink, FontAwesomeIcons.heart, "Service"),
    ],
  );
  whenWidget = ReminderWidget(
    "When...",
    [
      dateTile(Colors.pink, Duration(seconds: 5), "in 5s"),
      dateTile(Colors.pink, Duration(seconds: 30), "in 30s"),
      dateTile(Colors.pink, Duration(minutes: 1), "in 1m"),
      dateTile(Colors.pink, Duration(minutes: 2), "in 2m"),
      dateTile(Colors.deepOrange, Duration(minutes: 5), "in 5m"),
      dateTile(Colors.deepOrange, Duration(minutes: 10), "in 10m"),
      dateTile(Colors.deepOrange, Duration(minutes: 15), "in 15m"),
      dateTile(Colors.deepOrange, Duration(minutes: 30), "in 30m"),
      dateTile(Colors.amber, Duration(hours: 1), "in 1h"),
      dateTile(Colors.amber, Duration(hours: 1), "in 2h"),
      dateTile(Colors.amber, Duration(hours: 1), "in 6h"),
      dateTile(Colors.amber, Duration(hours: 1), "in 12h"),
      dateTile(Colors.green, Duration(days: 1), "in 1d"),
      dateTile(Colors.green, Duration(days: 1), "in 2d"),
      dateTile(Colors.green, Duration(days: 1), "in 7d"),
      dateTile(Colors.green, Duration(days: 1), "in 14d"),
      dateTile(Colors.blue, Duration(days: 30), "in 30d"),
      dateTile(Colors.blue, Duration(days: 60), "in 60d"),
      dateTile(Colors.blue, Duration(days: 182), "in 1/2y"),
      dateTile(Colors.blue, Duration(days: 365), "in 1y"),
    ],
  );

  runApp(new MaterialApp(
    title: 'Fast reminders',
    home: whatWidget,
  ));
}

DurationReminderTile dateTile(Color color, Duration duration, String text) =>
    DurationReminderTile(color, duration, text, dateCallback);

TextIconReminderTile whatTile(Color color, IconData icon, String text) =>
    TextIconReminderTile(color, icon, text, whatCallback);

TextIconReminderTile whoTile(Color color, IconData icon, String text) =>
    TextIconReminderTile(color, icon, text, whoCallback);

class ReminderWidget extends StatelessWidget {
  final String _title;
  final List<Widget> _tiles;

  ReminderWidget(this._title, this._tiles);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(_title),
        ),
        body: new Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: new GridView.count(
              crossAxisCount: 4,
              children: _tiles,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              padding: const EdgeInsets.all(4.0),
            )));
  }
}

abstract class ReminderTile<T> extends StatelessWidget {
  final Color backgroundColor;
  final Widget content;

  ReminderTile(this.backgroundColor, this.content, this.callback);

  final T callback;

  void onTap(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () => onTap(context),
        child: new Center(
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: content,
          ),
        ),
      ),
    );
  }
}

class TextIconReminderTile extends ReminderTile<onTextTapFunc> {
  final IconData iconData;
  final String text;

  TextIconReminderTile(backgroundColor, this.iconData, this.text, callback)
      : super(
            backgroundColor,
            new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(
                  text,
                  style: textStyle,
                ),
                new Icon(
                  iconData,
                  color: Colors.white,
                )
              ],
            ),
            callback);

  @override
  void onTap(BuildContext context) {
    callback(context, text);
  }
}

class DurationReminderTile extends ReminderTile<onDateTapFunc> {
  final Duration duration;

  DurationReminderTile(backgroundColor, this.duration, text, callback)
      : super(
            backgroundColor,
            new Text(
              text,
              style: textStyle,
            ),
            callback);

  @override
  void onTap(BuildContext context) {
    callback(context, new DateTime.now().add(duration));
  }
}

class ReminderBuilder {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ReminderBuilder(this.flutterLocalNotificationsPlugin);

  String who;
  String what;
  DateTime when;

  Future scheduleNotification(String message) async {
    await flutterLocalNotificationsPlugin.schedule(
        DateTime.now().millisecondsSinceEpoch,
        'Reminder',
        message,
        when,
        new NotificationDetails(
            new AndroidNotificationDetails(
              'id_fast_reminders_channel',
              'Fast Reminders',
              'Reminder notifications',
              sound: 'slow_spring_board',
              playSound: true,
            ),
            new IOSNotificationDetails(sound: "slow_spring_board.aiff")));
  }

  String createMessage() =>
      what +
      ' for ' +
      who +
      " at " +
      formatDate(when, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
}
