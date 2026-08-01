// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WatchlistsTable extends Watchlists
    with TableInfo<$WatchlistsTable, Watchlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchlistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symbolsMeta = const VerificationMeta(
    'symbols',
  );
  @override
  late final GeneratedColumn<String> symbols = GeneratedColumn<String>(
    'symbols',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, symbols];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watchlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Watchlist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbols')) {
      context.handle(
        _symbolsMeta,
        symbols.isAcceptableOrUnknown(data['symbols']!, _symbolsMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Watchlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Watchlist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      symbols: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbols'],
      )!,
    );
  }

  @override
  $WatchlistsTable createAlias(String alias) {
    return $WatchlistsTable(attachedDatabase, alias);
  }
}

class Watchlist extends DataClass implements Insertable<Watchlist> {
  final String id;
  final String name;
  final String symbols;
  const Watchlist({
    required this.id,
    required this.name,
    required this.symbols,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['symbols'] = Variable<String>(symbols);
    return map;
  }

  WatchlistsCompanion toCompanion(bool nullToAbsent) {
    return WatchlistsCompanion(
      id: Value(id),
      name: Value(name),
      symbols: Value(symbols),
    );
  }

  factory Watchlist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Watchlist(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      symbols: serializer.fromJson<String>(json['symbols']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'symbols': serializer.toJson<String>(symbols),
    };
  }

  Watchlist copyWith({String? id, String? name, String? symbols}) => Watchlist(
    id: id ?? this.id,
    name: name ?? this.name,
    symbols: symbols ?? this.symbols,
  );
  Watchlist copyWithCompanion(WatchlistsCompanion data) {
    return Watchlist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      symbols: data.symbols.present ? data.symbols.value : this.symbols,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Watchlist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbols: $symbols')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, symbols);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Watchlist &&
          other.id == this.id &&
          other.name == this.name &&
          other.symbols == this.symbols);
}

class WatchlistsCompanion extends UpdateCompanion<Watchlist> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> symbols;
  final Value<int> rowid;
  const WatchlistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.symbols = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WatchlistsCompanion.insert({
    required String id,
    required String name,
    required String symbols,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       symbols = Value(symbols);
  static Insertable<Watchlist> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? symbols,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (symbols != null) 'symbols': symbols,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WatchlistsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? symbols,
    Value<int>? rowid,
  }) {
    return WatchlistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      symbols: symbols ?? this.symbols,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbols.present) {
      map['symbols'] = Variable<String>(symbols.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchlistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbols: $symbols, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HoldingsTable extends Holdings with TableInfo<$HoldingsTable, Holding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HoldingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageCostMeta = const VerificationMeta(
    'averageCost',
  );
  @override
  late final GeneratedColumn<double> averageCost = GeneratedColumn<double>(
    'average_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [symbol, quantity, averageCost];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holdings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Holding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('average_cost')) {
      context.handle(
        _averageCostMeta,
        averageCost.isAcceptableOrUnknown(
          data['average_cost']!,
          _averageCostMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageCostMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol};
  @override
  Holding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Holding(
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      averageCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_cost'],
      )!,
    );
  }

  @override
  $HoldingsTable createAlias(String alias) {
    return $HoldingsTable(attachedDatabase, alias);
  }
}

class Holding extends DataClass implements Insertable<Holding> {
  final String symbol;
  final int quantity;
  final double averageCost;
  const Holding({
    required this.symbol,
    required this.quantity,
    required this.averageCost,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['quantity'] = Variable<int>(quantity);
    map['average_cost'] = Variable<double>(averageCost);
    return map;
  }

  HoldingsCompanion toCompanion(bool nullToAbsent) {
    return HoldingsCompanion(
      symbol: Value(symbol),
      quantity: Value(quantity),
      averageCost: Value(averageCost),
    );
  }

  factory Holding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Holding(
      symbol: serializer.fromJson<String>(json['symbol']),
      quantity: serializer.fromJson<int>(json['quantity']),
      averageCost: serializer.fromJson<double>(json['averageCost']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'quantity': serializer.toJson<int>(quantity),
      'averageCost': serializer.toJson<double>(averageCost),
    };
  }

  Holding copyWith({String? symbol, int? quantity, double? averageCost}) =>
      Holding(
        symbol: symbol ?? this.symbol,
        quantity: quantity ?? this.quantity,
        averageCost: averageCost ?? this.averageCost,
      );
  Holding copyWithCompanion(HoldingsCompanion data) {
    return Holding(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      averageCost: data.averageCost.present
          ? data.averageCost.value
          : this.averageCost,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Holding(')
          ..write('symbol: $symbol, ')
          ..write('quantity: $quantity, ')
          ..write('averageCost: $averageCost')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symbol, quantity, averageCost);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Holding &&
          other.symbol == this.symbol &&
          other.quantity == this.quantity &&
          other.averageCost == this.averageCost);
}

class HoldingsCompanion extends UpdateCompanion<Holding> {
  final Value<String> symbol;
  final Value<int> quantity;
  final Value<double> averageCost;
  final Value<int> rowid;
  const HoldingsCompanion({
    this.symbol = const Value.absent(),
    this.quantity = const Value.absent(),
    this.averageCost = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HoldingsCompanion.insert({
    required String symbol,
    required int quantity,
    required double averageCost,
    this.rowid = const Value.absent(),
  }) : symbol = Value(symbol),
       quantity = Value(quantity),
       averageCost = Value(averageCost);
  static Insertable<Holding> custom({
    Expression<String>? symbol,
    Expression<int>? quantity,
    Expression<double>? averageCost,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (quantity != null) 'quantity': quantity,
      if (averageCost != null) 'average_cost': averageCost,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HoldingsCompanion copyWith({
    Value<String>? symbol,
    Value<int>? quantity,
    Value<double>? averageCost,
    Value<int>? rowid,
  }) {
    return HoldingsCompanion(
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      averageCost: averageCost ?? this.averageCost,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (averageCost.present) {
      map['average_cost'] = Variable<double>(averageCost.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoldingsCompanion(')
          ..write('symbol: $symbol, ')
          ..write('quantity: $quantity, ')
          ..write('averageCost: $averageCost, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sideMeta = const VerificationMeta('side');
  @override
  late final GeneratedColumn<int> side = GeneratedColumn<int>(
    'side',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    symbol,
    side,
    quantity,
    price,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('side')) {
      context.handle(
        _sideMeta,
        side.isAcceptableOrUnknown(data['side']!, _sideMeta),
      );
    } else if (isInserting) {
      context.missing(_sideMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      side: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}side'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final String id;
  final String symbol;
  final int side;
  final int quantity;
  final double price;
  final DateTime timestamp;
  const Order({
    required this.id,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['symbol'] = Variable<String>(symbol);
    map['side'] = Variable<int>(side);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      symbol: Value(symbol),
      side: Value(side),
      quantity: Value(quantity),
      price: Value(price),
      timestamp: Value(timestamp),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<String>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      side: serializer.fromJson<int>(json['side']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'symbol': serializer.toJson<String>(symbol),
      'side': serializer.toJson<int>(side),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  Order copyWith({
    String? id,
    String? symbol,
    int? side,
    int? quantity,
    double? price,
    DateTime? timestamp,
  }) => Order(
    id: id ?? this.id,
    symbol: symbol ?? this.symbol,
    side: side ?? this.side,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    timestamp: timestamp ?? this.timestamp,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      side: data.side.present ? data.side.value : this.side,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('side: $side, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, symbol, side, quantity, price, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.side == this.side &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.timestamp == this.timestamp);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> id;
  final Value<String> symbol;
  final Value<int> side;
  final Value<int> quantity;
  final Value<double> price;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.side = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    required String id,
    required String symbol,
    required int side,
    required int quantity,
    required double price,
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       symbol = Value(symbol),
       side = Value(side),
       quantity = Value(quantity),
       price = Value(price),
       timestamp = Value(timestamp);
  static Insertable<Order> custom({
    Expression<String>? id,
    Expression<String>? symbol,
    Expression<int>? side,
    Expression<int>? quantity,
    Expression<double>? price,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (side != null) 'side': side,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? symbol,
    Value<int>? side,
    Value<int>? quantity,
    Value<double>? price,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      side: side ?? this.side,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (side.present) {
      map['side'] = Variable<int>(side.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('side: $side, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletTable extends Wallet with TableInfo<$WalletTable, WalletData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, balance];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
    );
  }

  @override
  $WalletTable createAlias(String alias) {
    return $WalletTable(attachedDatabase, alias);
  }
}

class WalletData extends DataClass implements Insertable<WalletData> {
  final int id;
  final double balance;
  const WalletData({required this.id, required this.balance});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['balance'] = Variable<double>(balance);
    return map;
  }

  WalletCompanion toCompanion(bool nullToAbsent) {
    return WalletCompanion(id: Value(id), balance: Value(balance));
  }

  factory WalletData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletData(
      id: serializer.fromJson<int>(json['id']),
      balance: serializer.fromJson<double>(json['balance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'balance': serializer.toJson<double>(balance),
    };
  }

  WalletData copyWith({int? id, double? balance}) =>
      WalletData(id: id ?? this.id, balance: balance ?? this.balance);
  WalletData copyWithCompanion(WalletCompanion data) {
    return WalletData(
      id: data.id.present ? data.id.value : this.id,
      balance: data.balance.present ? data.balance.value : this.balance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletData(')
          ..write('id: $id, ')
          ..write('balance: $balance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, balance);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletData &&
          other.id == this.id &&
          other.balance == this.balance);
}

class WalletCompanion extends UpdateCompanion<WalletData> {
  final Value<int> id;
  final Value<double> balance;
  const WalletCompanion({
    this.id = const Value.absent(),
    this.balance = const Value.absent(),
  });
  WalletCompanion.insert({
    this.id = const Value.absent(),
    required double balance,
  }) : balance = Value(balance);
  static Insertable<WalletData> custom({
    Expression<int>? id,
    Expression<double>? balance,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (balance != null) 'balance': balance,
    });
  }

  WalletCompanion copyWith({Value<int>? id, Value<double>? balance}) {
    return WalletCompanion(id: id ?? this.id, balance: balance ?? this.balance);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletCompanion(')
          ..write('id: $id, ')
          ..write('balance: $balance')
          ..write(')'))
        .toString();
  }
}

class $MarketTicksTable extends MarketTicks
    with TableInfo<$MarketTicksTable, MarketTick> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketTicksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeMeta = const VerificationMeta('change');
  @override
  late final GeneratedColumn<double> change = GeneratedColumn<double>(
    'change',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changePercentMeta = const VerificationMeta(
    'changePercent',
  );
  @override
  late final GeneratedColumn<double> changePercent = GeneratedColumn<double>(
    'change_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    symbol,
    price,
    change,
    changePercent,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'market_ticks';
  @override
  VerificationContext validateIntegrity(
    Insertable<MarketTick> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('change')) {
      context.handle(
        _changeMeta,
        change.isAcceptableOrUnknown(data['change']!, _changeMeta),
      );
    } else if (isInserting) {
      context.missing(_changeMeta);
    }
    if (data.containsKey('change_percent')) {
      context.handle(
        _changePercentMeta,
        changePercent.isAcceptableOrUnknown(
          data['change_percent']!,
          _changePercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_changePercentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol};
  @override
  MarketTick map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarketTick(
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      change: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}change'],
      )!,
      changePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}change_percent'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $MarketTicksTable createAlias(String alias) {
    return $MarketTicksTable(attachedDatabase, alias);
  }
}

class MarketTick extends DataClass implements Insertable<MarketTick> {
  final String symbol;
  final double price;
  final double change;
  final double changePercent;
  final DateTime timestamp;
  const MarketTick({
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['price'] = Variable<double>(price);
    map['change'] = Variable<double>(change);
    map['change_percent'] = Variable<double>(changePercent);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  MarketTicksCompanion toCompanion(bool nullToAbsent) {
    return MarketTicksCompanion(
      symbol: Value(symbol),
      price: Value(price),
      change: Value(change),
      changePercent: Value(changePercent),
      timestamp: Value(timestamp),
    );
  }

  factory MarketTick.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarketTick(
      symbol: serializer.fromJson<String>(json['symbol']),
      price: serializer.fromJson<double>(json['price']),
      change: serializer.fromJson<double>(json['change']),
      changePercent: serializer.fromJson<double>(json['changePercent']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'price': serializer.toJson<double>(price),
      'change': serializer.toJson<double>(change),
      'changePercent': serializer.toJson<double>(changePercent),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  MarketTick copyWith({
    String? symbol,
    double? price,
    double? change,
    double? changePercent,
    DateTime? timestamp,
  }) => MarketTick(
    symbol: symbol ?? this.symbol,
    price: price ?? this.price,
    change: change ?? this.change,
    changePercent: changePercent ?? this.changePercent,
    timestamp: timestamp ?? this.timestamp,
  );
  MarketTick copyWithCompanion(MarketTicksCompanion data) {
    return MarketTick(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      price: data.price.present ? data.price.value : this.price,
      change: data.change.present ? data.change.value : this.change,
      changePercent: data.changePercent.present
          ? data.changePercent.value
          : this.changePercent,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarketTick(')
          ..write('symbol: $symbol, ')
          ..write('price: $price, ')
          ..write('change: $change, ')
          ..write('changePercent: $changePercent, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(symbol, price, change, changePercent, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarketTick &&
          other.symbol == this.symbol &&
          other.price == this.price &&
          other.change == this.change &&
          other.changePercent == this.changePercent &&
          other.timestamp == this.timestamp);
}

class MarketTicksCompanion extends UpdateCompanion<MarketTick> {
  final Value<String> symbol;
  final Value<double> price;
  final Value<double> change;
  final Value<double> changePercent;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const MarketTicksCompanion({
    this.symbol = const Value.absent(),
    this.price = const Value.absent(),
    this.change = const Value.absent(),
    this.changePercent = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MarketTicksCompanion.insert({
    required String symbol,
    required double price,
    required double change,
    required double changePercent,
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  }) : symbol = Value(symbol),
       price = Value(price),
       change = Value(change),
       changePercent = Value(changePercent),
       timestamp = Value(timestamp);
  static Insertable<MarketTick> custom({
    Expression<String>? symbol,
    Expression<double>? price,
    Expression<double>? change,
    Expression<double>? changePercent,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (price != null) 'price': price,
      if (change != null) 'change': change,
      if (changePercent != null) 'change_percent': changePercent,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MarketTicksCompanion copyWith({
    Value<String>? symbol,
    Value<double>? price,
    Value<double>? change,
    Value<double>? changePercent,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return MarketTicksCompanion(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (change.present) {
      map['change'] = Variable<double>(change.value);
    }
    if (changePercent.present) {
      map['change_percent'] = Variable<double>(changePercent.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarketTicksCompanion(')
          ..write('symbol: $symbol, ')
          ..write('price: $price, ')
          ..write('change: $change, ')
          ..write('changePercent: $changePercent, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WatchlistsTable watchlists = $WatchlistsTable(this);
  late final $HoldingsTable holdings = $HoldingsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $WalletTable wallet = $WalletTable(this);
  late final $MarketTicksTable marketTicks = $MarketTicksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    watchlists,
    holdings,
    orders,
    wallet,
    marketTicks,
  ];
}

typedef $$WatchlistsTableCreateCompanionBuilder =
    WatchlistsCompanion Function({
      required String id,
      required String name,
      required String symbols,
      Value<int> rowid,
    });
typedef $$WatchlistsTableUpdateCompanionBuilder =
    WatchlistsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> symbols,
      Value<int> rowid,
    });

class $$WatchlistsTableFilterComposer
    extends Composer<_$AppDatabase, $WatchlistsTable> {
  $$WatchlistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbols => $composableBuilder(
    column: $table.symbols,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchlistsTableOrderingComposer
    extends Composer<_$AppDatabase, $WatchlistsTable> {
  $$WatchlistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbols => $composableBuilder(
    column: $table.symbols,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchlistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WatchlistsTable> {
  $$WatchlistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbols =>
      $composableBuilder(column: $table.symbols, builder: (column) => column);
}

class $$WatchlistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WatchlistsTable,
          Watchlist,
          $$WatchlistsTableFilterComposer,
          $$WatchlistsTableOrderingComposer,
          $$WatchlistsTableAnnotationComposer,
          $$WatchlistsTableCreateCompanionBuilder,
          $$WatchlistsTableUpdateCompanionBuilder,
          (
            Watchlist,
            BaseReferences<_$AppDatabase, $WatchlistsTable, Watchlist>,
          ),
          Watchlist,
          PrefetchHooks Function()
        > {
  $$WatchlistsTableTableManager(_$AppDatabase db, $WatchlistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WatchlistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WatchlistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WatchlistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> symbols = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WatchlistsCompanion(
                id: id,
                name: name,
                symbols: symbols,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String symbols,
                Value<int> rowid = const Value.absent(),
              }) => WatchlistsCompanion.insert(
                id: id,
                name: name,
                symbols: symbols,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WatchlistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WatchlistsTable,
      Watchlist,
      $$WatchlistsTableFilterComposer,
      $$WatchlistsTableOrderingComposer,
      $$WatchlistsTableAnnotationComposer,
      $$WatchlistsTableCreateCompanionBuilder,
      $$WatchlistsTableUpdateCompanionBuilder,
      (Watchlist, BaseReferences<_$AppDatabase, $WatchlistsTable, Watchlist>),
      Watchlist,
      PrefetchHooks Function()
    >;
typedef $$HoldingsTableCreateCompanionBuilder =
    HoldingsCompanion Function({
      required String symbol,
      required int quantity,
      required double averageCost,
      Value<int> rowid,
    });
typedef $$HoldingsTableUpdateCompanionBuilder =
    HoldingsCompanion Function({
      Value<String> symbol,
      Value<int> quantity,
      Value<double> averageCost,
      Value<int> rowid,
    });

class $$HoldingsTableFilterComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageCost => $composableBuilder(
    column: $table.averageCost,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HoldingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageCost => $composableBuilder(
    column: $table.averageCost,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HoldingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get averageCost => $composableBuilder(
    column: $table.averageCost,
    builder: (column) => column,
  );
}

class $$HoldingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HoldingsTable,
          Holding,
          $$HoldingsTableFilterComposer,
          $$HoldingsTableOrderingComposer,
          $$HoldingsTableAnnotationComposer,
          $$HoldingsTableCreateCompanionBuilder,
          $$HoldingsTableUpdateCompanionBuilder,
          (Holding, BaseReferences<_$AppDatabase, $HoldingsTable, Holding>),
          Holding,
          PrefetchHooks Function()
        > {
  $$HoldingsTableTableManager(_$AppDatabase db, $HoldingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HoldingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HoldingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HoldingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symbol = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> averageCost = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HoldingsCompanion(
                symbol: symbol,
                quantity: quantity,
                averageCost: averageCost,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symbol,
                required int quantity,
                required double averageCost,
                Value<int> rowid = const Value.absent(),
              }) => HoldingsCompanion.insert(
                symbol: symbol,
                quantity: quantity,
                averageCost: averageCost,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HoldingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HoldingsTable,
      Holding,
      $$HoldingsTableFilterComposer,
      $$HoldingsTableOrderingComposer,
      $$HoldingsTableAnnotationComposer,
      $$HoldingsTableCreateCompanionBuilder,
      $$HoldingsTableUpdateCompanionBuilder,
      (Holding, BaseReferences<_$AppDatabase, $HoldingsTable, Holding>),
      Holding,
      PrefetchHooks Function()
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      required String id,
      required String symbol,
      required int side,
      required int quantity,
      required double price,
      required DateTime timestamp,
      Value<int> rowid,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<String> id,
      Value<String> symbol,
      Value<int> side,
      Value<int> quantity,
      Value<double> price,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<int> get side =>
      $composableBuilder(column: $table.side, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
          Order,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<int> side = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                symbol: symbol,
                side: side,
                quantity: quantity,
                price: price,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String symbol,
                required int side,
                required int quantity,
                required double price,
                required DateTime timestamp,
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                symbol: symbol,
                side: side,
                quantity: quantity,
                price: price,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
      Order,
      PrefetchHooks Function()
    >;
typedef $$WalletTableCreateCompanionBuilder =
    WalletCompanion Function({Value<int> id, required double balance});
typedef $$WalletTableUpdateCompanionBuilder =
    WalletCompanion Function({Value<int> id, Value<double> balance});

class $$WalletTableFilterComposer
    extends Composer<_$AppDatabase, $WalletTable> {
  $$WalletTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletTable> {
  $$WalletTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletTable> {
  $$WalletTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);
}

class $$WalletTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletTable,
          WalletData,
          $$WalletTableFilterComposer,
          $$WalletTableOrderingComposer,
          $$WalletTableAnnotationComposer,
          $$WalletTableCreateCompanionBuilder,
          $$WalletTableUpdateCompanionBuilder,
          (WalletData, BaseReferences<_$AppDatabase, $WalletTable, WalletData>),
          WalletData,
          PrefetchHooks Function()
        > {
  $$WalletTableTableManager(_$AppDatabase db, $WalletTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> balance = const Value.absent(),
              }) => WalletCompanion(id: id, balance: balance),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double balance,
              }) => WalletCompanion.insert(id: id, balance: balance),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletTable,
      WalletData,
      $$WalletTableFilterComposer,
      $$WalletTableOrderingComposer,
      $$WalletTableAnnotationComposer,
      $$WalletTableCreateCompanionBuilder,
      $$WalletTableUpdateCompanionBuilder,
      (WalletData, BaseReferences<_$AppDatabase, $WalletTable, WalletData>),
      WalletData,
      PrefetchHooks Function()
    >;
typedef $$MarketTicksTableCreateCompanionBuilder =
    MarketTicksCompanion Function({
      required String symbol,
      required double price,
      required double change,
      required double changePercent,
      required DateTime timestamp,
      Value<int> rowid,
    });
typedef $$MarketTicksTableUpdateCompanionBuilder =
    MarketTicksCompanion Function({
      Value<String> symbol,
      Value<double> price,
      Value<double> change,
      Value<double> changePercent,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

class $$MarketTicksTableFilterComposer
    extends Composer<_$AppDatabase, $MarketTicksTable> {
  $$MarketTicksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get changePercent => $composableBuilder(
    column: $table.changePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MarketTicksTableOrderingComposer
    extends Composer<_$AppDatabase, $MarketTicksTable> {
  $$MarketTicksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get changePercent => $composableBuilder(
    column: $table.changePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MarketTicksTableAnnotationComposer
    extends Composer<_$AppDatabase, $MarketTicksTable> {
  $$MarketTicksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get change =>
      $composableBuilder(column: $table.change, builder: (column) => column);

  GeneratedColumn<double> get changePercent => $composableBuilder(
    column: $table.changePercent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$MarketTicksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MarketTicksTable,
          MarketTick,
          $$MarketTicksTableFilterComposer,
          $$MarketTicksTableOrderingComposer,
          $$MarketTicksTableAnnotationComposer,
          $$MarketTicksTableCreateCompanionBuilder,
          $$MarketTicksTableUpdateCompanionBuilder,
          (
            MarketTick,
            BaseReferences<_$AppDatabase, $MarketTicksTable, MarketTick>,
          ),
          MarketTick,
          PrefetchHooks Function()
        > {
  $$MarketTicksTableTableManager(_$AppDatabase db, $MarketTicksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketTicksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketTicksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketTicksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symbol = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> change = const Value.absent(),
                Value<double> changePercent = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MarketTicksCompanion(
                symbol: symbol,
                price: price,
                change: change,
                changePercent: changePercent,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symbol,
                required double price,
                required double change,
                required double changePercent,
                required DateTime timestamp,
                Value<int> rowid = const Value.absent(),
              }) => MarketTicksCompanion.insert(
                symbol: symbol,
                price: price,
                change: change,
                changePercent: changePercent,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MarketTicksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MarketTicksTable,
      MarketTick,
      $$MarketTicksTableFilterComposer,
      $$MarketTicksTableOrderingComposer,
      $$MarketTicksTableAnnotationComposer,
      $$MarketTicksTableCreateCompanionBuilder,
      $$MarketTicksTableUpdateCompanionBuilder,
      (
        MarketTick,
        BaseReferences<_$AppDatabase, $MarketTicksTable, MarketTick>,
      ),
      MarketTick,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WatchlistsTableTableManager get watchlists =>
      $$WatchlistsTableTableManager(_db, _db.watchlists);
  $$HoldingsTableTableManager get holdings =>
      $$HoldingsTableTableManager(_db, _db.holdings);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$WalletTableTableManager get wallet =>
      $$WalletTableTableManager(_db, _db.wallet);
  $$MarketTicksTableTableManager get marketTicks =>
      $$MarketTicksTableTableManager(_db, _db.marketTicks);
}
