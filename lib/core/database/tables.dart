import 'package:drift/drift.dart';

class Watchlists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get symbols => text()(); // Store as JSON string

  @override
  Set<Column> get primaryKey => {id};
}

class Holdings extends Table {
  TextColumn get symbol => text()();
  IntColumn get quantity => integer()();
  RealColumn get averageCost => real()();

  @override
  Set<Column> get primaryKey => {symbol};
}

class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get symbol => text()();
  IntColumn get side => integer()(); // 0: buy, 1: sell
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Wallet extends Table {
  IntColumn get id => integer()(); // Singleton, always 1
  RealColumn get balance => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class MarketTicks extends Table {
  TextColumn get symbol => text()();
  RealColumn get price => real()();
  RealColumn get change => real()();
  RealColumn get changePercent => real()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {symbol};
}
