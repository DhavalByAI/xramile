import 'package:flutter/material.dart';

import '../../main.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification List'),
      ),
      body: ListView.builder(
        itemCount: listOfNotifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listOfNotifications[index].title),
            subtitle: Text(listOfNotifications[index].body),
            trailing: Text(
              _formatDateTime(listOfNotifications[index].receivedTime),
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
