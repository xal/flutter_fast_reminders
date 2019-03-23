import 'package:fastreminders/reminder_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddToDoPage extends StatelessWidget {

  ReminderBuilder reminderBuilder;


  AddToDoPage(this.reminderBuilder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Fast reminders"),
        ),
        body: new RaisedButton(
            child: const Text('Connect with Twitter'),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            splashColor: Colors.blueGrey,
            onPressed: () {

              reminderBuilder.who = 'Partner';
              reminderBuilder.what = 'Buy smth';
              reminderBuilder.when = new DateTime.now().add(new Duration(seconds: 5));

              reminderBuilder.scheduleNotification();
            }));

//        body: GridView.count(
//            // Create a grid with 2 columns. If you change the scrollDirection to
//            // horizontal, this would produce 2 rows.
//            crossAxisCount: 3,
//            crossAxisSpacing: 5,
//            // Generate 100 Widgets that display their index in the List
//            children: List.generate(100, (index) {
//              return Center(
//                child: Text(
//                  'Item $index',
//                  style: Theme.of(context).textTheme.headline,
//                ),
//              );
//            })));
  }
}
