// data/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    return _database ??= await initDB();
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'wiggle.db');
    return openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await _createTables(db);
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Remove old fasting_records table if it exists
    await db.execute('DROP TABLE IF EXISTS fasting_records');

    // Create wishes table (formerly daily_tasks)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS wishes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        what TEXT NOT NULL,
        why TEXT NOT NULL,
        wish_when TEXT NOT NULL,
        wish_where TEXT NOT NULL,
        wish_who TEXT NOT NULL,
        wish_how TEXT NOT NULL,
        fulfilled INTEGER DEFAULT 0,
        importance INTEGER DEFAULT 3,
        category TEXT DEFAULT 'personal',
        reward TEXT
      )
    ''');

    // Enhanced character collection table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS character_collection (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        character_name TEXT,
        asset_path TEXT,
        rarity TEXT DEFAULT 'common',
        description TEXT DEFAULT '',
        is_unlocked INTEGER DEFAULT 1,
        is_golden INTEGER DEFAULT 0,
        happiness INTEGER DEFAULT 50,
        energy INTEGER DEFAULT 50,
        evolution_stage TEXT DEFAULT 'baby',
        last_interaction TEXT,
        fulfilled_wishes TEXT DEFAULT ''
      )
    ''');

    // Migrate old daily_tasks to wishes if they exist
    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='daily_tasks'");

    if (tables.isNotEmpty) {
      await db.execute('''
        INSERT INTO wishes (date, what, why, wish_when, wish_where, wish_who, wish_how, fulfilled, importance, category, reward)
        SELECT 
          date, 
          title as what,
          description as why,
          '' as wish_when,
          '' as wish_where,
          '' as wish_who,
          '' as wish_how,
          completed as fulfilled,
          priority as importance,
          task_type as category,
          reward
        FROM daily_tasks
      ''');

      await db.execute('DROP TABLE daily_tasks');
    }
  }

  // Helper method to reset database for testing
  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS wishes');
    await db.execute('DROP TABLE IF EXISTS character_collection');
    await _createTables(db);
  }
}
