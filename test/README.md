# Tests

## Overview

This project uses the standard Flutter three-layer testing approach:

- **Unit tests:** Pure Dart logic, no Flutter or device needed
- **Widget tests:** Flutter widget tree with mocked providers, no device needed
- **Integration tests:** Full app flows on a real device or emulator

All tests live under `test/`.

## Folder Structure

Example folder structure of what should be followed:

```
test/
├── unit/                          # Pure Dart logic
│   ├── shared/
│   │   ├── utils/                 # display_* helpers, formatters
│   │   └── converters/            # DoubleConverter, ExpenseKindConverter
│   └── features/
│       ├── auth/                  # AuthNotifier
│       ├── profile/               # ProfileNotifier
│       ├── wallet/                # WalletNotifier
│       └── category/              # CategoryNotifier
├── widget/                        # Flutter widget tree tests
│   ├── shared/                    # AppTile, CurrencyText, AppProgress, etc.
│   └── features/
│       ├── auth/                  # LoginScreen, OtpScreen
│       ├── transaction/           # TransactionTile, TransactionSheet
│       └── wallet/                # WalletTile, WalletSheet
├── integration/                   # End-to-end user flows
│   ├── auth_flow_test.dart        # Login -> OTP -> Dashboard
│   ├── transaction_flow_test.dart # Create -> view -> delete transaction
│   └── profile_switch_flow_test.dart
└── helpers/
    ├── mock_providers.dart        # Shared Riverpod provider overrides
    └── pump_app.dart              # Shared pumpApp() widget test wrapper
```

Files under `unit/` and `widget/` mirror `lib/` 1:1, with `_test.dart` suffix:

```
lib/shared/utils/display_currency.dart
-> test/unit/shared/utils/display_currency_test.dart

lib/features/auth/presentation/providers/auth_provider.dart
-> test/unit/features/auth/auth_notifier_test.dart

lib/shared/widgets/app_tile.dart
-> test/widget/shared/app_tile_test.dart

lib/features/auth/presentation/screens/login_screen.dart
-> test/widget/features/auth/login_screen_test.dart
```

Integration tests do not mirror a specific file. They are named after the user
story or flow they cover.

## Running Tests

**All tests:**

```bash
flutter test
```

**Unit tests only:**

```bash
flutter test test/unit
```

**Widget tests only:**

```bash
flutter test test/widget
```

**Integration tests only:**

```bash
flutter test test/integration
```

**Single file:**

```bash
flutter test test/unit/shared/utils/display_currency_test.dart
```

**With coverage:**

```bash
flutter test --coverage
```

## Key Conventions

- Notifier tests use `ProviderContainer` from `flutter_riverpod` to test state
  transitions in isolation.
- Widget tests use a shared `pumpApp()` helper from `test/helpers/pump_app.dart`
  that wraps the widget with `ProviderScope` and the app theme.
- Provider dependencies are mocked via overrides in
  `test/helpers/mock_providers.dart` and passed into `ProviderScope`.
- All test files must end in `_test.dart` to be picked up by the test runner.
