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

    return await openDatabase(path, version: 1, onCreate: _createDB);
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
