import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:expensetracker/app/data/repository/impulse_repository.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final ImpulseRepository _impulseRepository = Get.find<ImpulseRepository>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _onNotificationTapped(NotificationResponse response) async {
    // Handle notification tap - could navigate to journal
    Get.toNamed('/journal');
  }

  Future<void> scheduleImpulseCooldownNotification({
    required int itemId,
    required String itemName,
    required DateTime scheduledTime,
  }) async {
    await _notifications.zonedSchedule(
      itemId,
      'Impulse Cooldown Complete! 🎯',
      'Ready to decide on "$itemName"? Skip it and save money!',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'impulse_cooldown',
          'Impulse Cooldown Alerts',
          channelDescription: 'Notifications when impulse item cooldowns complete',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelImpulseNotification(int itemId) async {
    await _notifications.cancel(itemId);
  }

  Future<void> scheduleDailyExpenseReminder({
    required int hour,
    required int minute,
  }) async {
    await _notifications.zonedSchedule(
      999, // Fixed ID for daily reminder
      'Daily Expense Reminder 💰',
      'Don\'t forget to log your expenses today!',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Expense Reminders',
          channelDescription: 'Daily reminders to log expenses',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelDailyReminder() async {
    await _notifications.cancel(999);
  }

  // Show immediate notification for savings milestone
  Future<void> showSavingsMilestoneNotification(double totalSaved) async {
    String title = '';
    String body = '';

    if (totalSaved >= 10000) {
      title = 'Amazing! 🌟';
      body = 'You\'ve saved ৳${totalSaved.toInt()} by skipping impulse purchases!';
    } else if (totalSaved >= 5000) {
      title = 'Great Progress! 🎉';
      body = 'You\'ve saved ৳${totalSaved.toInt()} so far. Keep it up!';
    } else if (totalSaved >= 1000) {
      title = 'Nice Work! 👍';
      body = 'You\'ve saved ৳${totalSaved.toInt()} by being mindful!';
    }

    if (title.isNotEmpty) {
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'savings_milestone',
            'Savings Milestones',
            channelDescription: 'Celebrate your savings achievements',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: true,
          ),
        ),
      );
    }
  }
}