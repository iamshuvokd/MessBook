import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Local-only scheduling for the four reminder types in spec §6:
/// daily meal entry, recurring-expense due, month-end close, backup overdue.
class NotificationService {
  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const _mealReminderId = 1001;
  static const _monthCloseReminderId = 1002;
  static const _backupOverdueId = 1003;
  static const _chatMessageId = 1004;
  static const _memberJoinedId = 1005;
  static const _pollCreatedId = 1006;
  static const _lowBalanceId = 1007;
  // Recurring-expense-due ids start at 2000 + dayOfMonth to keep them stable per rule.
  static int recurringDueId(int dayOfMonth) => 2000 + dayOfMonth;
  static int pollReminderId(String pollId) => 3000 + (pollId.hashCode.abs() % 100000);

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings: initSettings);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await androidImpl?.requestNotificationsPermission() ?? false;
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));
    return scheduled;
  }

  Future<void> scheduleDailyMealReminder({required int hour, required int minute, required String title, required String body}) async {
    await init();
    await _plugin.zonedSchedule(
      id: _mealReminderId,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('meal_reminder', 'Meal reminders', importance: Importance.defaultImportance),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyMealReminder() async {
    await init();
    await _plugin.cancel(id: _mealReminderId);
  }

  Future<void> scheduleMonthCloseReminder({required DateTime lastDayOfMonth, required String title, required String body}) async {
    await init();
    final target = tz.TZDateTime(tz.local, lastDayOfMonth.year, lastDayOfMonth.month, lastDayOfMonth.day, 20, 0);
    if (target.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id: _monthCloseReminderId,
      title: title,
      body: body,
      scheduledDate: target,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('month_close', 'Month close reminders', importance: Importance.defaultImportance),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleRecurringDueReminder({
    required int dayOfMonth,
    required String title,
    required String body,
  }) async {
    await init();
    final now = tz.TZDateTime.now(tz.local);
    var target = tz.TZDateTime(tz.local, now.year, now.month, dayOfMonth, 9, 0);
    if (target.isBefore(now)) target = tz.TZDateTime(tz.local, now.year, now.month + 1, dayOfMonth, 9, 0);
    await _plugin.zonedSchedule(
      id: recurringDueId(dayOfMonth),
      title: title,
      body: body,
      scheduledDate: target,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('recurring_due', 'Recurring expense reminders', importance: Importance.defaultImportance),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future<void> cancelRecurringDueReminder(int dayOfMonth) async {
    await init();
    await _plugin.cancel(id: recurringDueId(dayOfMonth));
  }

  /// One-off reminder before a poll closes (e.g. 30 min before), scheduled
  /// at poll-creation time. Cancelled/rescheduled by re-calling with the
  /// same [pollId] if the close time changes.
  Future<void> schedulePollCloseReminder({
    required String pollId,
    required DateTime remindAt,
    required String title,
    required String body,
  }) async {
    await init();
    final target = tz.TZDateTime.from(remindAt, tz.local);
    if (target.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id: pollReminderId(pollId),
      title: title,
      body: body,
      scheduledDate: target,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('poll_reminder', 'Poll reminders', importance: Importance.defaultImportance),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelPollCloseReminder(String pollId) async {
    await init();
    await _plugin.cancel(id: pollReminderId(pollId));
  }

  /// Fired immediately (not scheduled) — called opportunistically on app
  /// open when the backup-overdue condition is met, throttled by the caller
  /// to at most once per day.
  Future<void> showBackupOverdueNow({required String title, required String body}) async {
    await init();
    await _plugin.show(
      id: _backupOverdueId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('backup_overdue', 'Backup reminders', importance: Importance.defaultImportance),
      ),
    );
  }

  /// Shown for an FCM chat push received while the app is in the
  /// foreground — Firebase Messaging never auto-displays a system
  /// notification in that state, only when backgrounded/killed, so the
  /// foreground case is handled the same way as every other in-app alert.
  Future<void> showChatMessage({required String title, required String body}) async {
    await init();
    await _plugin.show(
      id: _chatMessageId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('chat_message', 'Mess chat', importance: Importance.high),
      ),
    );
  }

  /// Shown for an FCM "member joined" push received in the foreground —
  /// same reasoning as [showChatMessage]. The sync that actually updates the
  /// Members list happens separately in [PushService], regardless of whether
  /// this visible notification is shown.
  Future<void> showMemberJoined({required String title, required String body}) async {
    await init();
    await _plugin.show(
      id: _memberJoinedId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('member_joined', 'Mess membership', importance: Importance.defaultImportance),
      ),
    );
  }

  Future<void> showLowBalance({required String title, required String body}) async {
    await init();
    await _plugin.show(
      id: _lowBalanceId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('low_balance', 'Low mess balance', importance: Importance.defaultImportance),
      ),
    );
  }

  Future<void> showPollCreated({required String title, required String body}) async {
    await init();
    await _plugin.show(
      id: _pollCreatedId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('poll_created', 'Meal polls', importance: Importance.defaultImportance),
      ),
    );
  }
}
