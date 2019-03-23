import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var whoWidget;
var whatWidget;
var whenWidget;

var notifications;
var whoStr;
var whatStr;
var whenDate;

var textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

typedef void TextFunc(BuildContext ctx, String text);
typedef void DateFunc(BuildContext ctx, DateTime date);

void moveTo(BuildContext ctx, Widget widget) => Navigator.push(
      ctx,
      MaterialPageRoute(builder: (ctx) => widget),
    );

void dateCallback(BuildContext ctx, DateTime date) {
  whenDate = date;
  schedule();
  SystemNavigator.pop();
}

void main() {
  notifications = FlutterLocalNotificationsPlugin();
  notifications.initialize(InitializationSettings(
      AndroidInitializationSettings('alarm'), IOSInitializationSettings()));
  var pink = Colors.pink;
  var blue = Colors.blue;
  var deepOrange = Colors.deepOrange;
  var green = Colors.green;
  var amber = Colors.amber;
  whatWidget = ReminderWidget(
    "Reminder about...",
    [
      what(Colors.grey, Icons.device_unknown, "Something"),
      what(Colors.indigo, Icons.add_shopping_cart, "Buy"),
      what(blue, Icons.call, "Call"),
      what(Colors.deepPurple, Icons.message, "Message"),
      what(Colors.black, Icons.attach_money, "Pay"),
      what(Colors.cyan, Icons.help, "Help"),
      what(Colors.brown, Icons.place, "Meet"),
      what(Colors.red, Icons.date_range, "Deadline"),
      what(Colors.deepPurpleAccent, Icons.check_circle, "Check"),
    ],
  );
  whoWidget = ReminderWidget(
    "For...",
    [
      who(Colors.grey, Icons.device_unknown, "Someone"),
      who(Colors.black, Icons.account_circle, "Me"),
      who(pink, Icons.favorite, "Partner"),
      who(green, Icons.group, "Family"),
      who(blue, Icons.group_work, "Friend"),
      who(Colors.purple, Icons.work, "Work"),
      who(Colors.red, Icons.healing, "Health"),
      who(pink, Icons.directions_car, "Car"),
      who(deepOrange, Icons.home, "Home"),
      who(Colors.brown, Icons.build, "Service"),
    ],
  );
  whenWidget = ReminderWidget(
    "After...",
    [
      date(pink, s(5), "5s"),
      date(pink, s(30), "30s"),
      date(pink, m(1), "1m"),
      date(pink, m(2), "2m"),
      date(deepOrange, m(5), "5m"),
      date(deepOrange, m(10), "10m"),
      date(deepOrange, m(15), "15m"),
      date(deepOrange, m(30), "30m"),
      date(amber, h(1), "1h"),
      date(amber, h(2), "2h"),
      date(amber, h(6), "6h"),
      date(amber, h(12), "12h"),
      date(green, d(1), "1d"),
      date(green, d(2), "2d"),
      date(green, d(7), "7d"),
      date(green, d(14), "14d"),
      date(blue, d(30), "30d"),
      date(blue, d(60), "60d"),
      date(blue, d(182), "1/2y"),
      date(blue, d(365), "1y"),
    ],
  );
  runApp(MaterialApp(
    title: 'Fast reminders',
    home: whatWidget,
  ));
}

Duration s(int s) => Duration(seconds: s);

Duration m(int m) => Duration(minutes: m);

Duration h(int h) => Duration(hours: h);

Duration d(int d) => Duration(days: d);

DurationTile date(Color color, Duration duration, String text) =>
    DurationTile(color, duration, text, dateCallback);

IconTile what(Color color, IconData icon, String text) =>
    IconTile(color, icon, text, (ctx, text) {
      whatStr = text;
      moveTo(ctx, whoWidget);
    });

IconTile who(Color color, IconData icon, String text) =>
    IconTile(color, icon, text, (ctx, text) {
      whoStr = text;
      moveTo(ctx, whenWidget);
    });

class ReminderWidget extends StatelessWidget {
  final String _title;
  final List<Widget> _tiles;

  ReminderWidget(this._title, this._tiles);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: GridView.count(
          crossAxisCount: 4,
          children: _tiles,
        ));
  }
}

abstract class Tile<T> extends StatelessWidget {
  final Color bg;
  final Widget content;

  Tile(this.bg, this.content, this.callback);

  final T callback;

  void onTap(BuildContext ctx);

  @override
  Widget build(BuildContext ctx) {
    return Card(
      color: bg,
      child: InkWell(
        onTap: () => onTap(ctx),
        child: Center(
          child: content,
        ),
      ),
    );
  }
}

class IconTile extends Tile<TextFunc> {
  final String text;

  IconTile(bg, icon, this.text, callback)
      : super(
            bg,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  text,
                  style: textStyle,
                ),
                Icon(
                  icon,
                  color: Colors.white,
                )
              ],
            ),
            callback);

  @override
  void onTap(BuildContext ctx) {
    callback(ctx, text);
  }
}

class DurationTile extends Tile<DateFunc> {
  final Duration duration;

  DurationTile(backgroundColor, this.duration, text, callback)
      : super(
            backgroundColor,
            Text(
              text,
              style: textStyle,
            ),
            callback);

  @override
  void onTap(BuildContext ctx) {
    callback(ctx, DateTime.now().add(duration));
  }
}

Future schedule() => notifications.schedule(
    0,
    'Reminder',
    whatStr + ' for ' + whoStr + " at " + whenDate,
    whenDate,
    NotificationDetails(
        AndroidNotificationDetails(
          'id',
          'Reminders',
          'Notifications',
        ),
        IOSNotificationDetails()));
