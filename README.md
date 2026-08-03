# 📈 Trading Application

A modular, clean-architected Flutter trading application built with **BLoC/Cubit state management**, **GetIt dependency injection**, and **Drift (SQLite) reactive local database**.

---

## 🌟 Key Features

### 📊 1. Market Feature (`lib/features/market/`)
- **Live Ticker & Prices**: Real-time stock tick updates and live price streaming via `LivePriceCubit`.
- **Market List**: Full list of tradable instruments and stocks via `MarketListCubit`.
- **Stock Indicators**: Dynamic stock rows displaying live price changes, percentage shifts, and market trends.

### 💼 2. Portfolio Feature (`lib/features/portfolio/`)
- **Holdings Management**: Tracks active asset holdings, buy prices, current prices, and quantity via `HoldingsCubit`.
- **Portfolio Analytics**: Live calculation of total portfolio value, total invested amount, and real-time Profit & Loss (P&L) stats via `PortfolioSummaryCubit`.

### ⚡ 3. Trading Feature (`lib/features/trading/`)
- **Order Execution**: Execute Market and Limit **BUY** and **SELL** orders via `TradingCubit`.
- **Wallet & Balance**: Real-time tracking of available cash balance, margin usage, and order fund allocation via `GetWalletUseCase`.
- **Order History**: History and status of filled, pending, and canceled orders.

### 📋 4. Watchlist Feature (`lib/features/watchlist/`)
- **Custom Watchlists**: Create, switch, and manage multiple personalized watchlists via `WatchlistCubit`.
- **Stock Picker**: Interactive selection dialog (`StockPickerDialog`) to search and add/remove stocks.
- **Watchlist Selector**: Bottom sheet (`WatchlistSelectorSheet`) for instant switching between user watchlists.

---

## 🏗️ Architecture & Package Structure

The project strictly follows **Clean Architecture** principles with a feature-first package layout:

```text
lib/
├── core/                       # Core shared infrastructure
│   ├── app/                    # Main App widget & GoRouter configuration
│   ├── config/                 # App configurations and themes
│   ├── constants/              # Global constants (colors, text styles, keys)
│   ├── database/               # Drift SQLite database schema, tables & DAOs
│   ├── di/                     # GetIt dependency injection setup
│   ├── error/                  # Domain failures & exception definitions
│   ├── presentation/           # Shared UI components & design system widgets
│   ├── usecases/               # Generic UseCase base interface
│   └── utils/                  # Formatters, extension functions & helpers
│
└── features/                   # Clean Architecture feature modules
    ├── market/                 # Market quotes & live ticker
    │   ├── data/               # Market models & Repository implementation
    │   ├── domain/             # Stock tick entities, Repository interface & UseCases
    │   └── presentation/       # Market list & Live price Cubits, MarketScreen, Stock rows
    ├── portfolio/              # Holdings & Portfolio tracking
    │   ├── data/               # Holding models & Local database sources
    │   ├── domain/             # Holding entity & Portfolio use cases
    │   └── presentation/       # Holdings/Summary Cubits, PortfolioScreen
    ├── trading/                # Order placement & Wallet management
    │   ├── data/               # Order/Wallet models & Data sources
    │   ├── domain/             # Order & Wallet entities, Trading use cases
    │   └── presentation/       # Trading Cubit, Order placement dialogs & Wallet widgets
    └── watchlist/              # Custom watchlists
        ├── data/               # Watchlist models & Data storage
        ├── domain/             # Watchlist entity & Repository interface
        └── presentation/       # Watchlist Cubit, WatchlistScreen & Stock picker dialogs
```

---

## 📦 Package & Dependency Breakdown

### Production Dependencies
| Package | Version | Purpose |
| :--- | :--- | :--- |
| [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) | `^9.1.1` | Predictable state management using BLoC / Cubit pattern |
| [`get_it`](https://pub.dev/packages/get_it) | `^9.2.1` | Service locator for Dependency Injection (DI) |
| [`go_router`](https://pub.dev/packages/go_router) | `^17.3.0` | Declarative route management and navigation |
| [`drift`](https://pub.dev/packages/drift) | `^2.34.3` | Reactive persistence library for local SQLite database |
| [`sqlite3_flutter_libs`](https://pub.dev/packages/sqlite3_flutter_libs) | `^0.6.0+eol` | Native SQLite binaries for mobile/desktop platforms |
| [`fpdart`](https://pub.dev/packages/fpdart) | `^1.2.0` | Functional programming utilities (`Either`, `Option`, etc.) |
| [`equatable`](https://pub.dev/packages/equatable) | `^2.1.0` | Value equality helper for Dart classes & BLoC states |
| [`uuid`](https://pub.dev/packages/uuid) | `^4.6.0` | Unique ID generator for orders and transactions |
| [`intl`](https://pub.dev/packages/intl) | `^0.20.3` | Number and currency formatting |
| [`logger`](https://pub.dev/packages/logger) | `^2.7.0` | Structured application logging |

### Development & Code Generation Dependencies
| Package | Version | Purpose |
| :--- | :--- | :--- |
| [`build_runner`](https://pub.dev/packages/build_runner) | `^2.15.1` | Code generation build tool |
| [`drift_dev`](https://pub.dev/packages/drift_dev) | `^2.34.0` | Schema compiler and code generator for Drift DB |
| [`freezed`](https://pub.dev/packages/freezed) | `^3.2.5` | Code generator for data classes & unions |
| [`json_serializable`](https://pub.dev/packages/json_serializable) | `^6.14.1` | JSON serialization code generator |
| [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) | `^0.14.3` | Native app icon generation |
| [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash) | `^2.4.6` | Native splash screen generation |

---

## 🚀 How to Run

### 1. Prerequisites
- **Flutter SDK**: `>= 3.11.5`
- **Dart SDK**: `>= 3.0.0`
- Target environment: iOS Simulator / macOS / Android Emulator / Chrome

### 2. Setup & Installation
```bash
# Clone the repository
git clone <repository-url>
cd trading

# Get dependencies
flutter pub get
```

### 3. Generate Database & Model Code
Run `build_runner` to generate Drift database code (`database.g.dart`):
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Launch Application
```bash
# Run on default connected device
flutter run

```


