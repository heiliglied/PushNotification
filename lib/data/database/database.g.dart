// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NotificationTable extends Notification
    with TableInfo<$NotificationTable, NotificationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentsMeta =
      const VerificationMeta('contents');
  @override
  late final GeneratedColumn<String> contents = GeneratedColumn<String>(
      'contents', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _alarmMeta = const VerificationMeta('alarm');
  @override
  late final GeneratedColumn<bool> alarm = GeneratedColumn<bool>(
      'alarm', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("alarm" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, date, title, contents, alarm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('contents')) {
      context.handle(_contentsMeta,
          contents.isAcceptableOrUnknown(data['contents']!, _contentsMeta));
    } else if (isInserting) {
      context.missing(_contentsMeta);
    }
    if (data.containsKey('alarm')) {
      context.handle(
          _alarmMeta, alarm.isAcceptableOrUnknown(data['alarm']!, _alarmMeta));
    } else if (isInserting) {
      context.missing(_alarmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      contents: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contents'])!,
      alarm: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}alarm'])!,
    );
  }

  @override
  $NotificationTable createAlias(String alias) {
    return $NotificationTable(attachedDatabase, alias);
  }
}

class NotificationData extends DataClass
    implements Insertable<NotificationData> {
  final int id;
  final DateTime date;
  final String title;
  final String contents;
  final bool alarm;
  const NotificationData(
      {required this.id,
      required this.date,
      required this.title,
      required this.contents,
      required this.alarm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['title'] = Variable<String>(title);
    map['contents'] = Variable<String>(contents);
    map['alarm'] = Variable<bool>(alarm);
    return map;
  }

  NotificationCompanion toCompanion(bool nullToAbsent) {
    return NotificationCompanion(
      id: Value(id),
      date: Value(date),
      title: Value(title),
      contents: Value(contents),
      alarm: Value(alarm),
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String>(json['title']),
      contents: serializer.fromJson<String>(json['contents']),
      alarm: serializer.fromJson<bool>(json['alarm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String>(title),
      'contents': serializer.toJson<String>(contents),
      'alarm': serializer.toJson<bool>(alarm),
    };
  }

  NotificationData copyWith(
          {int? id,
          DateTime? date,
          String? title,
          String? contents,
          bool? alarm}) =>
      NotificationData(
        id: id ?? this.id,
        date: date ?? this.date,
        title: title ?? this.title,
        contents: contents ?? this.contents,
        alarm: alarm ?? this.alarm,
      );
  NotificationData copyWithCompanion(NotificationCompanion data) {
    return NotificationData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      contents: data.contents.present ? data.contents.value : this.contents,
      alarm: data.alarm.present ? data.alarm.value : this.alarm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('contents: $contents, ')
          ..write('alarm: $alarm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, title, contents, alarm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationData &&
          other.id == this.id &&
          other.date == this.date &&
          other.title == this.title &&
          other.contents == this.contents &&
          other.alarm == this.alarm);
}

class NotificationCompanion extends UpdateCompanion<NotificationData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> title;
  final Value<String> contents;
  final Value<bool> alarm;
  const NotificationCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.contents = const Value.absent(),
    this.alarm = const Value.absent(),
  });
  NotificationCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String title,
    required String contents,
    required bool alarm,
  })  : date = Value(date),
        title = Value(title),
        contents = Value(contents),
        alarm = Value(alarm);
  static Insertable<NotificationData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? title,
    Expression<String>? contents,
    Expression<bool>? alarm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (contents != null) 'contents': contents,
      if (alarm != null) 'alarm': alarm,
    });
  }

  NotificationCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? title,
      Value<String>? contents,
      Value<bool>? alarm}) {
    return NotificationCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      contents: contents ?? this.contents,
      alarm: alarm ?? this.alarm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contents.present) {
      map['contents'] = Variable<String>(contents.value);
    }
    if (alarm.present) {
      map['alarm'] = Variable<bool>(alarm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('contents: $contents, ')
          ..write('alarm: $alarm')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $NotificationTable notification = $NotificationTable(this);
  late final NotificationDao notificationDao =
      NotificationDao(this as Database);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [notification];
}

typedef $$NotificationTableCreateCompanionBuilder = NotificationCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required String title,
  required String contents,
  required bool alarm,
});
typedef $$NotificationTableUpdateCompanionBuilder = NotificationCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> title,
  Value<String> contents,
  Value<bool> alarm,
});

class $$NotificationTableFilterComposer
    extends Composer<_$Database, $NotificationTable> {
  $$NotificationTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contents => $composableBuilder(
      column: $table.contents, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get alarm => $composableBuilder(
      column: $table.alarm, builder: (column) => ColumnFilters(column));
}

class $$NotificationTableOrderingComposer
    extends Composer<_$Database, $NotificationTable> {
  $$NotificationTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contents => $composableBuilder(
      column: $table.contents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get alarm => $composableBuilder(
      column: $table.alarm, builder: (column) => ColumnOrderings(column));
}

class $$NotificationTableAnnotationComposer
    extends Composer<_$Database, $NotificationTable> {
  $$NotificationTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contents =>
      $composableBuilder(column: $table.contents, builder: (column) => column);

  GeneratedColumn<bool> get alarm =>
      $composableBuilder(column: $table.alarm, builder: (column) => column);
}

class $$NotificationTableTableManager extends RootTableManager<
    _$Database,
    $NotificationTable,
    NotificationData,
    $$NotificationTableFilterComposer,
    $$NotificationTableOrderingComposer,
    $$NotificationTableAnnotationComposer,
    $$NotificationTableCreateCompanionBuilder,
    $$NotificationTableUpdateCompanionBuilder,
    (
      NotificationData,
      BaseReferences<_$Database, $NotificationTable, NotificationData>
    ),
    NotificationData,
    PrefetchHooks Function()> {
  $$NotificationTableTableManager(_$Database db, $NotificationTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> contents = const Value.absent(),
            Value<bool> alarm = const Value.absent(),
          }) =>
              NotificationCompanion(
            id: id,
            date: date,
            title: title,
            contents: contents,
            alarm: alarm,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String title,
            required String contents,
            required bool alarm,
          }) =>
              NotificationCompanion.insert(
            id: id,
            date: date,
            title: title,
            contents: contents,
            alarm: alarm,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $NotificationTable,
    NotificationData,
    $$NotificationTableFilterComposer,
    $$NotificationTableOrderingComposer,
    $$NotificationTableAnnotationComposer,
    $$NotificationTableCreateCompanionBuilder,
    $$NotificationTableUpdateCompanionBuilder,
    (
      NotificationData,
      BaseReferences<_$Database, $NotificationTable, NotificationData>
    ),
    NotificationData,
    PrefetchHooks Function()>;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$NotificationTableTableManager get notification =>
      $$NotificationTableTableManager(_db, _db.notification);
}
