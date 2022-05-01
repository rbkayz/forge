import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

// class NotificationService {
//
//   /// To know more about how this works, go to https://github.com/afzalali15/flutter_alarm_clock/blob/master/lib/main.dart
//
//
//   static final NotificationService _notificationService =
//   NotificationService._internal();
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   NotificationService._internal();
//
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//
//   Future<void> init() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('forge_icon');
//
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
//     );
//
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//         macOS: null);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//           if (payload != null) {
//             print('notification payload: ' + payload);
//           }
//         });
//   }
//
//
//
//   /// Sets up a scheduled notification at a particular time
//   void scheduleNotification(DateTime scheduledNotificationDateTime) async {
//
//     tz.initializeTimeZones();
//
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'forge',
//       'Reminder',
//       channelDescription: 'forge Daily Reminder',
//       icon: 'forge_icon',
//     );
//
//     var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true);
//
//
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(0, 'Notification', 'hello world',
//         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics, androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, payload: 'test');
//   }
//
//
//
//   void showDailyAtTime() async {
//
//     tz.initializeTimeZones();
//
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'forge',
//       'Reminder',
//       channelDescription: 'forge Daily Reminder',
//       icon: 'forge_icon',
//     );
//
//     var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true);
//
//
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'Daily Reminder',
//         'You have 10 catch-ups scheduled in this week',
//         _nextInstanceOfTenAM(),
//         platformChannelSpecifics,
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//         payload: 'test'
//     );
//
//
//   }
//
//   tz.TZDateTime _nextInstanceOfTenAM() {
//
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//
//     tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 13, 49).subtract(DateTime.now().timeZoneOffset);
//     //tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
//
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     return scheduledDate;
//   }
//
// }

Future<void> createStaticNotification() async {

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'Default',
      title:
      'Hello World',
      body: 'You have 10 pieces remaining',
    ),
  );

}


Future<void> createScheduledNotification(TimeOfDay? schedule) async {


  //TODO add details on notification text

  if(schedule != null ) {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'Default',
        title: 'Hello World',
        body: 'Scheduled Notifications',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: schedule.hour,
        minute: schedule.minute,
        second: 0,
        millisecond: 0,
      ),
    );
  }

}



int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}



Future<TimeOfDay?> pickSchedule(BuildContext context,) async {

  TimeOfDay? timeOfDay;

  timeOfDay = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.dial,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
    useRootNavigator: false,
    confirmText: 'CONFIRM',
    cancelText: 'CANCEL',
    helpText: 'PICK A DAILY REMINDER TIME'

        );

  return timeOfDay;
}


Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}