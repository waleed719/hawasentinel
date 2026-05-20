# Implementation Plan: Native Streak Widget & Daily Notifications

We will accomplish this by integrating native Android widget support via the `home_widget` package and revising the local notification strategy using `flutter_local_notifications` combined with the `timezone` package.

## Proposed Changes

### Ad-hoc Architecture Integrations
- Initialize `timezone/data/latest_all.dart` in `main.dart` or `NotificationService` to enable exact time local notifications.
- Add `home_widget` mapping in `StatsProvider`'s `_saveStats()` method to continuously synchronize the app’s internal current streak with native Android SharedPreferences.

### Native Android Streak Widget (Kotlin/XML)
#### [NEW] `android/app/src/main/res/layout/streak_widget_layout.xml`
- Create a secure UI matching typical progress widgets (e.g., similar to Duolingo) showing a fire icon and current streak count.

#### [NEW] `android/app/src/main/res/xml/streak_widget_info.xml`
- Define sizing metadata and constraints for the Home Widget.

#### [NEW] `android/app/src/main/kotlin/com/waleed/mind_forge/StreakAppWidgetProvider.kt`
- Create a native `AppWidgetProvider` extending class that reads the streak data natively from Android SharedPreferences (saved by Flutter) and populates the widget `TextView`.

#### [MODIFY] `android/app/src/main/AndroidManifest.xml`
- Declare the `<receiver>` for `StreakAppWidgetProvider` within the `<application>` manifest block.

### Smart Daily Notifications
#### [MODIFY] `lib/services/notification_service.dart`
- **Timezone Fixing**: Update `_convertToTZDateTime` logic to properly return a localized `TZDateTime`, resolving standard silent crashes.
- **Dynamic Scheduling**: Update `scheduleDailyReminder` to correctly handle skip-logic:
  - If a user completes their training, schedule the notification starting **tomorrow** at their chosen time, skipping today. 
  - If a user has not trained today and the time has already passed, schedule it for tomorrow.

#### [MODIFY] `lib/presentation/providers/stats_provider.dart`
- In `updateDailyStats()` or `_loadStats()`, hook in the logic:
  - `HomeWidget.saveWidgetData('current_streak', newStreak)`
  - `HomeWidget.updateWidget(name: 'StreakAppWidgetProvider')` 
  - Call `NotificationService().scheduleDailyReminder(time: TimeOfDay(hour: 9, minute: 0))` whenever the streak modifies, so it reliably pushes the next notification up. 

## Open Questions
- Do you have a specific time in mind for the default notification, or should we continue to use `09:00 AM`? (I plan to use 9 AM).
- Should tapping the Streak widget open right to the `DashboardPage`? (Standard approach).

## Verification Plan
- **Widget**: Add the widget to the Android Home Screen natively. Complete a mission and observe the widget dynamically update its streak count.
- **Notifications**: Trigger a mission completion, modify system time, and trace debug logs to verify that the next `zonedSchedule` is set correctly for tomorrow at 9 AM, canceling the redundant alert for today.
