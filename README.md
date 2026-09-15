# Expense Tracker

A privacy-first personal-finance app built with Flutter. Expense Tracker turns everyday spending into useful feedback: users can set a monthly budget, record expenses in seconds, review category and weekly trends, and use an impulse-purchase cooldown to make more intentional buying decisions.

The project is designed as a maintainable, feature-first Flutter codebase. It keeps presentation, application state, persistence, networking, and shared infrastructure clearly separated so that features can evolve without turning screens into business-logic containers.

<p align="center">
  <img src="img.png" alt="Daily budget and expense overview" width="18%" />
  <img src="img_1.png" alt="Impulse purchase journal" width="18%" />
  <img src="img_2.png" alt="Financial insights overview" width="18%" />
  <img src="img_3.png" alt="Spending category breakdown" width="18%" />
  <img src="img_4.png" alt="Privacy and export settings" width="18%" />
</p>

## Highlights

- **Daily money overview** — tracks today’s spending, remaining daily budget, recent expenses, and a three-month spending trend.
- **Budget management** — stores a budget per month and derives the daily allowance from the actual number of days in that month.
- **Fast, structured expense capture** — validates amount and merchant data, supports categories and notes, and persists entries locally.
- **Impulse Journal** — encourages mindful spending through 24-hour, 48-hour, or 7-day cooldowns. Users can later mark an item as bought or skipped and see the savings from skipped purchases.
- **Actionable analytics** — calculates monthly totals and comparisons, category breakdowns, four-week spending, impulse-decision activity, and weekly/monthly summaries.
- **Private by default** — financial data is stored on-device in SQLite; no account or backend is required for core tracking.
- **Data portability** — exports expenses and impulse-journal data as CSV.
- **Mobile-ready experience** — responsive Flutter UI, local notification service support, and English/Bengali localization resources.

## Architecture at a glance

This project applies clean, layered architecture principles in a practical Flutter structure. A feature owns its view, controller, and route binding; the controller never talks directly to SQLite or HTTP. It coordinates user interactions through repositories, which own the data-facing work.

```text
┌────────────────────────────────────────────────────────────┐
│ Presentation                                                 │
│ Views · reusable widgets · GetX reactive UI (`Obx`)          │
└──────────────────────────────┬─────────────────────────────┘
                               │ user intent / state updates
┌──────────────────────────────▼─────────────────────────────┐
│ Feature controllers                                          │
│ Validation · UI state · lifecycle · orchestration            │
└──────────────────────────────┬─────────────────────────────┘
                               │ repository boundary
┌──────────────────────────────▼─────────────────────────────┐
│ Data layer                                                   │
│ Expense / Insights / Impulse repositories · typed models    │
└─────────────────┬───────────────────────────┬──────────────┘
                  │                           │
┌─────────────────▼─────────────┐ ┌───────────▼──────────────┐
│ Local data                     │ │ Remote data               │
│ DatabaseHelper · SQLite         │ │ Dio · data sources        │
│ Preferences                     │ │ error translation         │
└───────────────────────────────┘ └──────────────────────────┘
```

### Why this structure matters

- **Views stay focused on rendering.** Feature views compose widgets and listen to observable state; form validation, loading, and persistence orchestration live in their controllers.
- **Controllers are testable units of UI behavior.** `HomeController`, `JournalController`, `InsightController`, and their peers own feature state, lifecycle cleanup, refresh flows, and user feedback—not SQL statements or network requests.
- **Repositories form the data boundary.** `ExpenseRepository`, `ImpulseRepository`, and `InsightsRepository` expose business-focused operations such as `getTodaySpent`, `makeDecision`, and `getSpendingComparison`. This keeps database implementation details outside the presentation layer.
- **Infrastructure is centralized.** `DatabaseHelper` owns schema and CRUD implementation; `DioProvider`, remote sources, request headers, retry support, and typed exceptions provide one reusable network foundation.
- **Cross-cutting UI behavior is shared.** `BaseController` standardizes page states, loading/error/success messaging, logging, and asynchronous error handling. Shared widgets, constants, models, and utilities live under `app/core` rather than being duplicated across features.

## Dependency injection and routing

GetX is used deliberately for state management, route composition, and dependency injection.

1. `InitialBinding` registers application-wide data dependencies at startup, including local preferences, remote data sources, and repository abstractions.
2. Feature bindings register only what a route needs. For example, `HomeBinding` provides `ExpenseRepository` and `HomeController`, while `QuickExpenseBinding` provides its form-specific controller.
3. `Get.lazyPut` defers object creation until it is needed. Long-lived main-area controllers use `fenix: true` where recreation after disposal is appropriate.
4. The remote GitHub example demonstrates abstraction-to-implementation registration: a `GithubRemoteDataSource` interface is bound to `GithubRemoteDataSourceImpl`, and `GithubRepository` is bound to `GithubRepositoryImpl`.
5. `AppPages` keeps route names, pages, and bindings together, giving each screen a clear composition root.

This means a screen can be added as a small vertical slice—**view + controller + binding + route**—without changing unrelated features or creating global dependency sprawl.

## Project structure

```text
lib/
├── main.dart / main_dev.dart / main_prod.dart  # application entry points
├── flavors/                                   # environment configuration
├── l10n/                                      # English and Bengali resources
└── app/
    ├── bindings/                              # app-level dependency registration
    ├── routes/                                # GetX pages and route constants
    ├── modules/                               # feature-first presentation slices
    │   ├── home/
    │   ├── quick_expense/
    │   ├── journal/
    │   ├── insights/
    │   ├── settings/
    │   └── ...
    ├── data/
    │   ├── model/                             # Expense, Budget, ImpulseItem
    │   ├── local/                             # SQLite and preferences
    │   ├── remote/                            # remote-source interfaces/implementations
    │   └── repository/                        # data-access and analytics boundaries
    ├── network/                               # Dio setup, interceptors, retry, exceptions
    ├── core/                                  # base classes, shared UI, values, utilities
    └── services/                              # local notification service
```

## Persistence model

The local SQLite database is initialized through a singleton `DatabaseHelper` and contains three focused tables:

| Table | Responsibility |
| --- | --- |
| `expenses` | Amount, category, merchant, optional note, and timestamp for each recorded expense. |
| `budgets` | Monthly budget amount and its derived daily amount. |
| `impulse_items` | Item details, desire level, cooldown timing, decision status, and final decision date. |

Models encapsulate serialization at the boundary with `toJson`, `fromJson`, and `copyWith`. That keeps timestamp conversion and database map handling out of widgets and controllers.

## Technology choices

| Area | Implementation |
| --- | --- |
| UI | Flutter and Material Design |
| State, DI, navigation | GetX |
| Local persistence | SQLite via `sqflite` |
| Lightweight preferences | `shared_preferences` |
| Networking | Dio with logging, headers, retry support, and error mapping |
| Charts | `fl_chart` |
| Notifications | `flutter_local_notifications` with timezone-aware scheduling |
| Localization | Flutter localization resources for English and Bengali |

## Getting started

### Prerequisites

- Flutter SDK compatible with the project’s Dart SDK constraint (`^3.8.1`)
- An Android emulator/device or an iOS simulator/device configured for Flutter development

### Run locally

```bash
git clone <your-repository-url>
cd ExpenseTracker
flutter pub get
flutter run -t lib/main.dart
```

The project also provides environment-specific entry points:

```bash
# Development configuration
flutter run -t lib/main_dev.dart

# Production configuration
flutter run -t lib/main_prod.dart
```

`EnvConfig` and `BuildConfig` keep the application name, base URL, logging, and environment type outside of feature code. This avoids scattering environment checks through the UI or data layers.

## Quality checks

Before opening a pull request or release build, run:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Roadmap

- Automated tests for repositories, controllers, and database migrations
- CSV import and a completed end-to-end data reset flow
- Configurable notification preferences wired to scheduled reminders
- Expanded locale coverage and accessibility review

## What this project demonstrates

Expense Tracker is more than a UI exercise. It demonstrates how to build a Flutter application with clear ownership boundaries: feature-driven presentation code, reactive state management, lazy dependency injection, repository-mediated data access, local-first persistence, shared error handling, and configuration that is ready to scale beyond a single environment.
