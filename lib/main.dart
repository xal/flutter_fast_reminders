// This sample shows creation of a [Card] widget that can be tapped. When
// tapped this [Card]'s [InkWell] displays an "ink splash" that fills the
// entire card.

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


ReminderBuilder reminderBuilder;
ReminderWidget whoWidget;
ReminderWidget whatWidget;
ReminderWidget whenWidget;

var textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

typedef void TextFunc(BuildContext context, String text);
typedef void DateFunc(BuildContext context, DateTime date);

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

  var duration = new Duration(seconds: 1);
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text("Scheduled: " + message),
    duration: duration,
  ));

  Future.delayed(duration, () {
    Navigator.popUntil(context, (route) => route.isFirst);
    SystemNavigator.pop();
  });
}

void main() {
  var notifications = new FlutterLocalNotificationsPlugin();

  notifications.initialize(new InitializationSettings(
      new AndroidInitializationSettings('ic_access_alarm_black_24dp'),
      new IOSInitializationSettings()));

  reminderBuilder = new ReminderBuilder(notifications);

  var pink = Colors.pink;
  var blue = Colors.blue;
  var deepOrange = Colors.deepOrange;
  var green = Colors.green;
  whatWidget = ReminderWidget(
    "Reminder about...",
    [
      what(Colors.grey, FontAwesomeIcons.questionCircle, "Something"),
      what(Colors.indigo, Icons.add_shopping_cart, "Buy"),
      what(blue, Icons.call, "Call"),
      what(Colors.deepPurple, Icons.message, "Message"),
      what(Colors.teal, Icons.monetization_on, "Debt"),
      what(Colors.black, Icons.attach_money, "Pay"),
      what(Colors.cyan, Icons.help, "Help"),
      what(pink, FontAwesomeIcons.handHoldingHeart, "Give"),
      what(Colors.redAccent, FontAwesomeIcons.handPointer, "Get"),
      what(Colors.brown, Icons.place, "Meet"),
      what(Colors.red, Icons.date_range, "Deadline"),
      what(Colors.deepPurpleAccent, Icons.check_circle, "Check"),
    ],
  );

  whoWidget = ReminderWidget(
    "For...",
    [
      who(Colors.grey, FontAwesomeIcons.questionCircle, "Someone"),
      who(Colors.black, Icons.account_circle, "Me"),
      who(pink, FontAwesomeIcons.heart, "Partner"),
      who(green, FontAwesomeIcons.users, "Family"),
      who(blue, FontAwesomeIcons.userFriends, "Friend"),
      who(Colors.purple, FontAwesomeIcons.building, "Work"),
      who(Colors.purpleAccent, FontAwesomeIcons.briefcase, "Client"),
      who(Colors.deepPurpleAccent, FontAwesomeIcons.crown, "Boss"),
      who(Colors.red, FontAwesomeIcons.heartBroken, "Health"),
      who(pink, FontAwesomeIcons.car, "Car"),
      who(deepOrange, FontAwesomeIcons.home, "Home"),
      who(Colors.brown, FontAwesomeIcons.conciergeBell, "Service"),
    ],
  );
  var amber = Colors.amber;
  whenWidget = ReminderWidget(
    "When...",
    [
      date(pink, s(5), "in 5s"),
      date(pink, s(30), "in 30s"),
      date(pink, m(1), "in 1m"),
      date(pink, m(2), "in 2m"),
      date(deepOrange, m(5), "in 5m"),
      date(deepOrange, m(10), "in 10m"),
      date(deepOrange, m(15), "in 15m"),
      date(deepOrange, m(30), "in 30m"),
      date(amber, h(1), "in 1h"),
      date(amber, h(1), "in 2h"),
      date(amber, h(1), "in 6h"),
      date(amber, h(1), "in 12h"),
      date(green, d(1), "in 1d"),
      date(green, d(1), "in 2d"),
      date(green, d(1), "in 7d"),
      date(green, d(1), "in 14d"),
      date(blue, d(30), "in 30d"),
      date(blue, d(60), "in 60d"),
      date(blue, d(182), "in 1/2y"),
      date(blue, d(365), "in 1y"),
    ],
  );

  runApp(new MaterialApp(
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
    IconTile(color, icon, text, whatCallback);

IconTile who(Color color, IconData icon, String text) =>
    IconTile(color, icon, text, whoCallback);

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

abstract class Tile<T> extends StatelessWidget {
  final Color bg;
  final Widget content;

  Tile(this.bg, this.content, this.callback);

  final T callback;

  void onTap(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: bg,
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

class IconTile extends Tile<TextFunc> {
  final IconData icon;
  final String text;

  IconTile(backgroundColor, this.icon, this.text, callback)
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
                  icon,
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

class DurationTile extends Tile<DateFunc> {
  final Duration duration;

  DurationTile(backgroundColor, this.duration, text, callback)
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
  FlutterLocalNotificationsPlugin notifications;

  ReminderBuilder(this.notifications);

  String who;
  String what;
  DateTime when;

  Future scheduleNotification(String message) async {
    await notifications.schedule(
        0,
        'Reminder',
        message,
        when,
        new NotificationDetails(
            new AndroidNotificationDetails(
              'id',
              'Reminders',
              'Notifications',
            ),
            new IOSNotificationDetails()));
  }

  String createMessage() =>
      what +
      ' for ' +
      who +
      " at " +
      formatDate(when, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
}
