# Test Cases

This catalogue defines the functional acceptance cases for Expense Tracker. It
is intentionally traceable to the current Flutter implementation, so that it
can be used both for a manual release check and as the backlog for automated
unit, repository-integration, and widget tests.

## Status and scope

- **Test case** means a specified behaviour to verify. It is not a claim that
  the case has been executed or passed.
- Initial automated coverage is implemented under `test/` (unit and widget
  tests) and `integration_test/` (device smoke test). Test results and
  coverage figures are intentionally not claimed until they are run in CI.
- **Ready to automate** cases have a clear source boundary and expected
  assertion. **Acceptance gap** cases describe important user-facing behaviour
  that the current implementation does not yet complete; they must remain
  visible rather than being reported as passing.

### Test environments

Run the functional cases on a clean Android emulator/device and an iOS
simulator/device, with a physical device used for storage and notification
checks. For deterministic calculations, use a controlled date/time or test
fixtures. Start every data-changing case with the stated fixture and clean it
up through the database test harness; do not use a real user's finance data.

### Recommended automated layers

| Layer | Purpose | Primary targets |
| --- | --- | --- |
| Unit | Fast, deterministic rules and model behaviour | `Expense`, `Budget`, `ImpulseItem`, validation, month/day calculations, analytics helpers |
| Repository integration | SQLite CRUD, aggregation, ordering, and persistence | `DatabaseHelper`, `ExpenseRepository`, `ImpulseRepository`, `InsightsRepository` |
| Widget / integration | Real user paths, visible feedback, navigation, and state refresh | Home, Quick Expense, Journal, Insights, Settings, splash and bottom navigation |

### Implemented automated coverage

| Test file | Cases exercised |
| --- | --- |
| `test/unit/expense_and_budget_model_test.dart` | Expense and budget serialization/copy behaviour |
| `test/unit/impulse_item_test.dart` | Impulse serialization, cooldown state/progress, and immutable decisions |
| `test/widget/bottom_nav_bar_test.dart` | NAV-02 menu selection and selected index |
| `test/widget/quick_expense_view_test.dart` | Quick Expense form/budget rendering and category selection |
| `integration_test/app_smoke_test.dart` | NAV-01 launch/splash path, EXP-01 create/display flow, and navigation to the Journal |

## Functional test cases

| ID | Level | Scenario and test data | Expected result | Traceability | Status |
| --- | --- | --- | --- | --- | --- |
| NAV-01 | Widget | Launch a fresh install and wait for the splash animation. | Splash transitions to the main screen after its configured delay; Home is selected. | `SplashView`, `AppPages`, `MainView` | Ready to automate |
| NAV-02 | Widget | Tap Home, Journal, Insights, and Settings in the bottom navigation. | The selected tab and its matching feature view change together; the selected view remains usable when revisited. | `BottomNavBar`, `MainController`, `MainView` | Ready to automate |
| BUD-01 | Repository integration | With no budget for the current month, load Home or Quick Expense. | One default monthly budget of BDT 18,000 is stored and the daily amount equals monthly amount divided by the actual days in the current month. | `ExpenseRepository.setBudget`, `HomeController.loadBudgetData`, `QuickExpenseController.loadBudgetData` | Ready to automate |
| BUD-02 | Unit / repository integration | Set a monthly budget in a 30-day month, then in a 31-day month and February in a leap year. | Daily amount is calculated using 30, 31, and 29 days respectively; no fixed 30-day assumption is used. | `ExpenseRepository.setBudget` | Ready to automate |
| BUD-03 | Widget / repository integration | Enter a valid positive monthly amount in the Home budget dialog and save it twice. | The current month's existing budget is updated, daily allowance refreshes, and no duplicate current-month budget is created. | `HomeController.updateBudget`, `DatabaseHelper.updateBudget` | Ready to automate |
| BUD-04 | Widget | Enter blank, zero, negative, and non-numeric budget values. | An error is shown and the stored budget remains unchanged. | `HomeController.updateBudget` | Ready to automate |
| EXP-01 | Widget / repository integration | Add a Home expense: BDT 250, Food, merchant `Lunch Corner`, optional note `Team lunch`. | A success message is shown; the record is persisted with all entered fields; today's total, remaining budget, and recent-expense list refresh. | `HomeController.addExpense`, `ExpenseRepository.addExpense` | Ready to automate |
| EXP-02 | Widget | Attempt to save a Home expense with blank amount, non-numeric amount, and blank merchant. | Validation feedback is shown for each invalid input; no expense is persisted. | `HomeController._validateExpenseForm` | Ready to automate |
| EXP-03 | Widget / repository integration | Add an expense on the Quick Expense route with a valid prior date, category, amount, and description. | The chosen date, category, amount, and description-as-merchant are persisted; the route closes after success. | `QuickExpenseController.selectDate`, `QuickExpenseController.addExpense` | Ready to automate |
| EXP-04 | Widget | Open the Quick Expense date picker. Try choosing a future date and a date more than 365 days ago. | Future dates and dates outside the previous 365 days cannot be selected. | `QuickExpenseController.selectDate` | Ready to automate |
| EXP-05 | Repository integration | Seed several expenses on one day at different times, then query that date. | Only that calendar day's records are returned, in descending timestamp order; the total equals the sum of their amounts. | `DatabaseHelper.getExpensesByDate`, `getTotalSpentForDate` | Ready to automate |
| EXP-06 | Repository integration | Add expenses, terminate the app, relaunch, and load Home. | SQLite-backed expenses and the current monthly budget remain available after restart. | `DatabaseHelper`, `ExpenseRepository`, `HomeController.loadHomeData` | Ready to automate |
| EXP-07 | Widget | Open a saved expense's detail screen with and without a note. | Merchant, amount, category, date, and category icon are displayed; the Notes row appears only when a note exists. | `HomeController.showExpenseDetails`, `ExpenseDetailsView` | Ready to automate |
| EXP-08 | Widget | Confirm deletion from Transaction Details, then return to Home and reload. | The record should be removed and totals refreshed. | `ExpenseDetailsView._confirmDeleteExpense` | **Acceptance gap** - the view currently displays success but does not call a deletion repository/controller method. |
| JRN-01 | Widget | Open Add Impulse Item and submit a blank name, then a blank/zero/non-numeric price. | A validation message is shown; no item is created. | `JournalController._validateForm` | Ready to automate |
| JRN-02 | Widget / repository integration | Create an item with a 24-hour cooldown; repeat for 48 hours and 7 days. | The selected duration, end time, category, desire level, and optional notes are persisted; the item appears in the waiting list. | `ImpulseConstants.cooldownOptions`, `JournalController.addImpulseItem` | Ready to automate |
| JRN-03 | Unit | Build waiting items before and after their cooldown end time. | `isCooldownComplete` is false before the end, true after it; `remainingCooldown` never becomes negative and progress is clamped from 0 to 100 percent. | `ImpulseItem` | Ready to automate |
| JRN-04 | Repository integration | Mark a waiting item as **Skipped**. | Its status and decision timestamp update; it moves to completed items; skipped price contributes to total savings and statistics. | `ImpulseRepository.makeDecision`, `getTotalSavings`, `getStats` | Ready to automate |
| JRN-05 | Repository integration | Mark another waiting item as **Bought**. | It moves to completed items with a decision timestamp but does not increase saved amount. | `ImpulseRepository.makeDecision` | Ready to automate |
| JRN-06 | Repository integration | Create two completed items, one skipped and one bought. | Success rate is `skipped / (skipped + bought) * 100`; it is 0 when neither decision exists. | `ImpulseRepository.getSuccessRate` | Ready to automate |
| JRN-07 | Widget / repository integration | Delete a waiting or completed impulse item. | The item is removed and waiting/completed lists, savings, and statistics reload. | `JournalController.deleteImpulseItem` | Ready to automate |
| NTF-01 | Device integration | With notification service registered and OS permission granted, add an impulse item with a near-term test cooldown; make a decision before the scheduled time. | A cooldown notification is scheduled for the end time and is cancelled when the decision is recorded. | `NotificationService`, `JournalController` | Ready to automate after service registration is wired at app startup |
| INS-01 | Repository integration | Seed current-month expenses across Food, Transport, and Shopping. | Category totals and the monthly total equal the seeded data; the largest total is selected as top category. | `InsightsRepository.getExpensesByCategory`, `getTotalSpending`, `getTopSpendingCategory` | Ready to automate |
| INS-02 | Repository integration | Seed expenses for the current and previous month, including a previous-month total of zero. | Comparison reports both totals and computes percentage change only when the previous total is positive; zero baseline returns 0 percent rather than an invalid value. | `InsightsRepository.getSpendingComparison` | Ready to automate |
| INS-03 | Repository integration | Seed expenses and impulse decisions across the last four weeks. | Four ordered weekly records are returned with correct spending/decision counts, including zero-value weeks. | `InsightsRepository.getWeeklySpending`, `getWeeklyImpulseDecisions` | Ready to automate |
| INS-04 | Widget | Refresh Insights after adding an expense and after skipping an impulse item. | Category breakdown, totals, summaries, four-week series, and savings progress refresh without crashing on empty data. | `InsightController.loadInsightsData`, `onRefresh` | Ready to automate |
| SET-01 | Device integration | Export expenses and impulse items containing commas, quotes, and line breaks. | A CSV with the documented header is written to Downloads or the fallback location; fields are escaped with valid CSV quoting. | `SettingsController.exportData`, `_escapeCsvField` | Ready to automate |
| SET-02 | Widget / device integration | Use the visible Settings screen to open storage information, About, Privacy Policy, Contact Support, and Export. | Each available setting opens its dialog/snackbar or begins export without an unhandled error. | `SettingsView`, `SettingsController` | Ready to automate |
| SET-03 | Widget / repository integration | Confirm **Clear all data**, relaunch the app, and inspect expenses, budgets, and impulse items. | All user data should be deleted only after confirmation, and the UI should reflect an empty state. | `SettingsController.clearAllData` | **Acceptance gap** - the current confirmation shows success but does not clear the SQLite tables. |
| SET-04 | Widget | Inspect the Settings screen and try notification preference controls and CSV import. | If presented, preferences should persist and import should either work or be visibly labelled unavailable. | `SettingsView._buildNotificationsSection`, `SettingsController.importData` | **Acceptance gap** - notification controls are not rendered and CSV import is explicitly not implemented. |
| LOC-01 | Widget | Start the app under English and Bengali locales; inspect app chrome and primary feature screens. | All supported UI strings should be localized and text should remain legible without clipping. | `MyApp.supportedLocales`, `lib/l10n/` | Ready to automate; audit needed because many feature strings are currently literals. |
| RES-01 | Device integration | Enter representative data, switch the device offline, restart the app, and repeat Home, Journal, and Insights reads. | Core expense, budget, impulse, and insight views remain usable from SQLite without a network connection. | `DatabaseHelper`, local repositories | Ready to automate |

## Release gate

Before a portfolio demo, release candidate, or pull request, record the device,
OS, build identifier, tester, date, and observed result for every applicable
case above. A release is blocked by any failed data-loss, persistence,
calculation, validation, or offline-first case, and by every **Acceptance gap**
unless the feature is hidden or labelled unavailable.

Run these checks after dependencies resolve:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

The next implementation step is to create a `test/` suite from the **Ready to
automate** cases, beginning with model and repository tests, then controller
tests with fakes, and finally the widget/device flows. Keep test results and
coverage reports in CI rather than editing this specification to imply a pass.
