import 'package:own_yourself/utils/types.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HabitDatabase {
  static final HabitDatabase instance = HabitDatabase._init();
  static Database? _database;

  HabitDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habit_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        habitRepetitionType TEXT NOT NULL,
        habitRepetitionTimes INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT
      )
    ''');
    await db.execute('''
    CREATE TABLE habit_logs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      habit_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      completed_count INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE,
      UNIQUE (habit_id, date)
    )
  ''');

    await db.execute(
      'CREATE INDEX idx_habit_logs_habit_id ON habit_logs(habit_id)',
    );
    await db.execute('CREATE INDEX idx_habit_logs_date ON habit_logs(date)');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE habit_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        completed_count INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE,
        UNIQUE (habit_id, date)
      )
    ''');

      await db.execute(
        'CREATE INDEX idx_habit_logs_habit_id ON habit_logs(habit_id)',
      );
      await db.execute('CREATE INDEX idx_habit_logs_date ON habit_logs(date)');
    }
  }

  Future<int> insertHabit(HabitEntity habit) async {
    final db = await instance.database;
    return await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HabitEntity>> getAllHabits() async {
    final db = await instance.database;

    final result = await db.query('habits');

    return result.map((map) => HabitEntity.fromMap(map)).toList();
  }
}
