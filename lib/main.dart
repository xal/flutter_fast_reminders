import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var whoWidget;
var whatWidget;
var whenWidget;

var notifications;
var whoString;
var whatString;
var whenDate;

var textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

typedef void TextFunc(BuildContext ctx, String text);

void moveTo(BuildContext ctx, Widget widget) =>
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => widget));

void main() {
  notifications = FlutterLocalNotificationsPlugin();
  notifications.initialize(InitializationSettings(
      AndroidInitializationSettings('alarm'), IOSInitializationSettings()));
  var pink = Colors.pink;
  var blue = Colors.blue;
  var orange = Colors.orange;
  var green = Colors.green;
  var brown = Colors.brown;
  whatWidget = ReminderWidget(
    "About...",
    [
      what(Colors.grey, Icons.device_unknown, "Something"),
      what(Colors.indigo, Icons.shopping_cart, "Buy"),
      what(blue, Icons.call, "Call"),
      what(green, Icons.message, "Message"),
      what(Colors.black, Icons.attach_money, "Pay"),
      what(orange, Icons.help, "Help"),
      what(brown, Icons.place, "Meet"),
      what(Colors.red, Icons.date_range, "Deadline"),
      what(Colors.deepPurpleAccent, Icons.check_circle, "Check")
    ],
  );
  whoWidget = ReminderWidget(
    "For...",
    [
      who(Colors.grey, Icons.device_unknown, "Someone"),
      who(Colors.black, Icons.account_circle, "Me"),
      who(pink, Icons.favorite, "Love"),
      who(green, Icons.group, "Family"),
      who(blue, Icons.group_work, "Friend"),
      who(Colors.purple, Icons.work, "Work"),
      who(Colors.red, Icons.healing, "Health"),
      who(pink, Icons.directions_car, "Car"),
      who(orange, Icons.home, "Home"),
      who(brown, Icons.build, "Service")
    ],
  );
  whenWidget = ReminderWidget(
    "After...",
    [
      date(pink, s(5), "5s"),
      date(pink, s(30), "30s"),
      date(pink, m(1), "1m"),
      date(pink, m(2), "2m"),
      date(orange, m(5), "5m"),
      date(orange, m(10), "10m"),
      date(orange, m(15), "15m"),
      date(orange, m(30), "30m"),
      date(brown, h(1), "1h"),
      date(brown, h(2), "2h"),
      date(brown, h(6), "6h"),
      date(brown, h(12), "12h"),
      date(green, d(1), "1d"),
      date(green, d(2), "2d"),
      date(green, d(7), "7d"),
      date(green, d(14), "14d"),
      date(blue, d(30), "30d"),
      date(blue, d(60), "60d"),
      date(blue, d(182), "1/2y"),
      date(blue, d(365), "1y")
    ],
  );
  runApp(MaterialApp(title: 'Fast reminders', home: whatWidget));
}

Duration s(int s) => Duration(seconds: s);

Duration m(int m) => Duration(minutes: m);

Duration h(int h) => Duration(hours: h);

Duration d(int d) => Duration(days: d);

DurationTile date(Color color, Duration duration, String text) =>
    DurationTile(color, duration, text);

IconTile what(Color color, IconData icon, String text) =>
    IconTile(color, icon, text, (ctx, text) {
      whatString = text;
      moveTo(ctx, whoWidget);
    });

IconTile who(Color color, IconData icon, String text) =>
    IconTile(color, icon, text, (ctx, text) {
      whoString = text;
      moveTo(ctx, whenWidget);
    });

class ReminderWidget extends StatelessWidget {
  final String _title;
  final List<Widget> _tiles;

  ReminderWidget(this._title, this._tiles);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: GridView.count(crossAxisCount: 4, children: _tiles));
  }
}

abstract class Tile extends StatelessWidget {
  final Color bg;
  final Widget content;

  Tile(this.bg, this.content);

  void onTap(BuildContext ctx);

  @override
  Widget build(BuildContext ctx) {
    return Card(
        color: bg,
        child: InkWell(onTap: () => onTap(ctx), child: Center(child: content)));
  }
}

class IconTile extends Tile {
  final String text;

  final TextFunc callback;

  IconTile(bg, icon, this.text, this.callback)
      : super(
            bg,
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(text, style: textStyle),
                  Icon(icon, color: Colors.white)
                ]));

  @override
  void onTap(BuildContext ctx) {
    callback(ctx, text);
  }
}

class DurationTile extends Tile {
  final Duration duration;

  DurationTile(bg, this.duration, text)
      : super(bg, Text(text, style: textStyle));

  @override
  void onTap(BuildContext ctx) {
    whenDate = DateTime.now().add(duration);
    schedule();
    SystemNavigator.pop();
  }
}

Future schedule() => notifications.schedule(
    0,
    'Reminder',
    "$whatString for $whoString at " +
        formatDate(
            whenDate, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]),
    whenDate,
    NotificationDetails(
        AndroidNotificationDetails('id', 'Reminders', 'Notifications'),
        IOSNotificationDetails()));
