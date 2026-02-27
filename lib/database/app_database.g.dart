// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitRepetitionTypeMeta =
      const VerificationMeta('habitRepetitionType');
  @override
  late final GeneratedColumn<String> habitRepetitionType =
      GeneratedColumn<String>(
        'habit_repetition_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _habitRepetitionTimesMeta =
      const VerificationMeta('habitRepetitionTimes');
  @override
  late final GeneratedColumn<int> habitRepetitionTimes = GeneratedColumn<int>(
    'habit_repetition_times',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    habitRepetitionType,
    habitRepetitionTimes,
    startDate,
    endDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('habit_repetition_type')) {
      context.handle(
        _habitRepetitionTypeMeta,
        habitRepetitionType.isAcceptableOrUnknown(
          data['habit_repetition_type']!,
          _habitRepetitionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_habitRepetitionTypeMeta);
    }
    if (data.containsKey('habit_repetition_times')) {
      context.handle(
        _habitRepetitionTimesMeta,
        habitRepetitionTimes.isAcceptableOrUnknown(
          data['habit_repetition_times']!,
          _habitRepetitionTimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_habitRepetitionTimesMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      habitRepetitionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_repetition_type'],
      )!,
      habitRepetitionTimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_repetition_times'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final int id;
  final String title;
  final String habitRepetitionType;
  final int habitRepetitionTimes;
  final DateTime startDate;
  final DateTime? endDate;
  const Habit({
    required this.id,
    required this.title,
    required this.habitRepetitionType,
    required this.habitRepetitionTimes,
    required this.startDate,
    this.endDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['habit_repetition_type'] = Variable<String>(habitRepetitionType);
    map['habit_repetition_times'] = Variable<int>(habitRepetitionTimes);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      title: Value(title),
      habitRepetitionType: Value(habitRepetitionType),
      habitRepetitionTimes: Value(habitRepetitionTimes),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      habitRepetitionType: serializer.fromJson<String>(
        json['habitRepetitionType'],
      ),
      habitRepetitionTimes: serializer.fromJson<int>(
        json['habitRepetitionTimes'],
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'habitRepetitionType': serializer.toJson<String>(habitRepetitionType),
      'habitRepetitionTimes': serializer.toJson<int>(habitRepetitionTimes),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  Habit copyWith({
    int? id,
    String? title,
    String? habitRepetitionType,
    int? habitRepetitionTimes,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
  }) => Habit(
    id: id ?? this.id,
    title: title ?? this.title,
    habitRepetitionType: habitRepetitionType ?? this.habitRepetitionType,
    habitRepetitionTimes: habitRepetitionTimes ?? this.habitRepetitionTimes,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      habitRepetitionType: data.habitRepetitionType.present
          ? data.habitRepetitionType.value
          : this.habitRepetitionType,
      habitRepetitionTimes: data.habitRepetitionTimes.present
          ? data.habitRepetitionTimes.value
          : this.habitRepetitionTimes,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('habitRepetitionType: $habitRepetitionType, ')
          ..write('habitRepetitionTimes: $habitRepetitionTimes, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    habitRepetitionType,
    habitRepetitionTimes,
    startDate,
    endDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.title == this.title &&
          other.habitRepetitionType == this.habitRepetitionType &&
          other.habitRepetitionTimes == this.habitRepetitionTimes &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> habitRepetitionType;
  final Value<int> habitRepetitionTimes;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.habitRepetitionType = const Value.absent(),
    this.habitRepetitionTimes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String habitRepetitionType,
    required int habitRepetitionTimes,
    required DateTime startDate,
    this.endDate = const Value.absent(),
  }) : title = Value(title),
       habitRepetitionType = Value(habitRepetitionType),
       habitRepetitionTimes = Value(habitRepetitionTimes),
       startDate = Value(startDate);
  static Insertable<Habit> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? habitRepetitionType,
    Expression<int>? habitRepetitionTimes,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (habitRepetitionType != null)
        'habit_repetition_type': habitRepetitionType,
      if (habitRepetitionTimes != null)
        'habit_repetition_times': habitRepetitionTimes,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  HabitsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? habitRepetitionType,
    Value<int>? habitRepetitionTimes,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      habitRepetitionType: habitRepetitionType ?? this.habitRepetitionType,
      habitRepetitionTimes: habitRepetitionTimes ?? this.habitRepetitionTimes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (habitRepetitionType.present) {
      map['habit_repetition_type'] = Variable<String>(
        habitRepetitionType.value,
      );
    }
    if (habitRepetitionTimes.present) {
      map['habit_repetition_times'] = Variable<int>(habitRepetitionTimes.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('habitRepetitionType: $habitRepetitionType, ')
          ..write('habitRepetitionTimes: $habitRepetitionTimes, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [habits];
}

typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      required String title,
      required String habitRepetitionType,
      required int habitRepetitionTimes,
      required DateTime startDate,
      Value<DateTime?> endDate,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> habitRepetitionType,
      Value<int> habitRepetitionTimes,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
    });

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitRepetitionType => $composableBuilder(
    column: $table.habitRepetitionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get habitRepetitionTimes => $composableBuilder(
    column: $table.habitRepetitionTimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitRepetitionType => $composableBuilder(
    column: $table.habitRepetitionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get habitRepetitionTimes => $composableBuilder(
    column: $table.habitRepetitionTimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get habitRepetitionType => $composableBuilder(
    column: $table.habitRepetitionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get habitRepetitionTimes => $composableBuilder(
    column: $table.habitRepetitionTimes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
          Habit,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> habitRepetitionType = const Value.absent(),
                Value<int> habitRepetitionTimes = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                title: title,
                habitRepetitionType: habitRepetitionType,
                habitRepetitionTimes: habitRepetitionTimes,
                startDate: startDate,
                endDate: endDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String habitRepetitionType,
                required int habitRepetitionTimes,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                title: title,
                habitRepetitionType: habitRepetitionType,
                habitRepetitionTimes: habitRepetitionTimes,
                startDate: startDate,
                endDate: endDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
      Habit,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
}
