import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var whoW;
var whatW;
var whenW;

var notifications;
var whoS;
var whatS;
var whenD;

var textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

typedef void TextFunc(BuildContext ctx, String text);
typedef void DateFunc(BuildContext ctx, DateTime date);

void moveTo(BuildContext ctx, Widget widget) =>
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => widget));

void main() {
  notifications = FlutterLocalNotificationsPlugin();
  notifications.initialize(InitializationSettings(
      AndroidInitializationSettings('alarm'), IOSInitializationSettings()));
  var p = Colors.pink;
  var bl = Colors.blue;
  var o = Colors.orange;
  var g = Colors.green;
  var b = Colors.brown;
  whatW = ReminderWidget(
    "About...",
    [
      what(Colors.grey, Icons.device_unknown, "Something"),
      what(Colors.indigo, Icons.add_shopping_cart, "Buy"),
      what(bl, Icons.call, "Call"),
      what(g, Icons.message, "Message"),
      what(Colors.black, Icons.attach_money, "Pay"),
      what(o, Icons.help, "Help"),
      what(b, Icons.place, "Meet"),
      what(Colors.red, Icons.date_range, "Deadline"),
      what(Colors.deepPurpleAccent, Icons.check_circle, "Check")
    ],
  );
  whoW = ReminderWidget(
    "For...",
    [
      who(Colors.grey, Icons.device_unknown, "Someone"),
      who(Colors.black, Icons.account_circle, "Me"),
      who(p, Icons.favorite, "Love"),
      who(g, Icons.group, "Family"),
      who(bl, Icons.group_work, "Friend"),
      who(Colors.purple, Icons.work, "Work"),
      who(Colors.red, Icons.healing, "Health"),
      who(p, Icons.directions_car, "Car"),
      who(o, Icons.home, "Home"),
      who(b, Icons.build, "Service")
    ],
  );
  whenW = ReminderWidget(
    "After...",
    [
      date(p, s(5)),
      date(p, s(30)),
      date(p, m(1)),
      date(p, m(2)),
      date(o, m(5)),
      date(o, m(10)),
      date(o, m(15)),
      date(o, m(30)),
      date(b, h(1)),
      date(b, h(2)),
      date(b, h(6)),
      date(b, h(12)),
      date(g, d(1)),
      date(g, d(2)),
      date(g, d(7)),
      date(g, d(14)),
      date(bl, d(30)),
      date(bl, d(60)),
      date(bl, d(182)),
      date(bl, d(365))
    ],
  );
  runApp(MaterialApp(title: 'Fast reminders', home: whatW));
}

List s(int s) => [Duration(seconds: s), "$s s"];

List m(int m) => [Duration(minutes: m), "$m m"];

List h(int h) => [Duration(hours: h), "$h m"];

List d(int d) => [Duration(days: d), "$d d"];

DurationTile date(Color color, List list) =>
    DurationTile(color, list[0], list[1], (ctx, date) {
      whenD = date;
      schedule();
      SystemNavigator.pop();
    });

IconTile what(Color color, IconData icon, String text) =>
    IconTile(color, icon, text, (ctx, text) {
      whatS = text;
      moveTo(ctx, whoW);
    });

IconTile who(Color color, IconData icon, String text) =>
    IconTile(color, icon, text, (ctx, text) {
      whoS = text;
      moveTo(ctx, whenW);
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
        child: InkWell(onTap: () => onTap(ctx), child: Center(child: content)));
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
                  Text(text, style: textStyle),
                  Icon(icon, color: Colors.white)
                ]),
            callback);

  @override
  void onTap(BuildContext ctx) {
    callback(ctx, text);
  }
}

class DurationTile extends Tile<DateFunc> {
  final Duration duration;

  DurationTile(backgroundColor, this.duration, text, callback)
      : super(backgroundColor, Text(text, style: textStyle), callback);

  @override
  void onTap(BuildContext ctx) {
    callback(ctx, DateTime.now().add(duration));
  }
}

Future schedule() => notifications.schedule(
    0,
    'Reminder',
    whatS + ' for ' + whoS + " at " + whenD,
    whenD,
    NotificationDetails(
        AndroidNotificationDetails('id', 'Reminders', 'Notifications'),
        IOSNotificationDetails()));
