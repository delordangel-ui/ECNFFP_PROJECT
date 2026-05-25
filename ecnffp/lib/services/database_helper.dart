import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ecnffp_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE provinces (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE specialties (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE management_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE candidates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lastName TEXT NOT NULL,
        postName TEXT NOT NULL,
        firstName TEXT NOT NULL,
        birthDate TEXT NOT NULL,
        center TEXT NOT NULL,
        centerCode TEXT NOT NULL,
        school TEXT NOT NULL,
        schoolCode TEXT NOT NULL,
        provinceName TEXT NOT NULL,
        provinceCode TEXT NOT NULL,
        specialtyName TEXT NOT NULL,
        specialtyCode TEXT NOT NULL,
        managementTypeName TEXT NOT NULL,
        managementTypeCode TEXT NOT NULL,
        gender TEXT NOT NULL,
        photoPath TEXT,
        studentCode TEXT,
        isDeleted INTEGER DEFAULT 0,
        isCodified INTEGER DEFAULT 0,
        orderNumber INTEGER NOT NULL,
        UNIQUE(lastName, postName, firstName)
      )
    ''');

    await db.execute('''
      CREATE TABLE scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        candidateId INTEGER NOT NULL,
        redaction REAL,
        sipDpo REAL,
        day1 REAL,
        day2 REAL,
        day3 REAL,
        day4 REAL,
        FOREIGN KEY (candidateId) REFERENCES candidates (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    // Default passcodes and passwords
    await db.insert('settings', {'key': 'code_1012', 'value': '1012'}); // Admin
    await db.insert('settings', {'key': 'pass_1012', 'value': 'admin123'});

    await db.insert('settings', {'key': 'code_3345', 'value': '3345'}); // National
    await db.insert('settings', {'key': 'pass_3345', 'value': 'min123'});

    await db.insert('settings', {'key': 'code_2597', 'value': '2597'}); // Province
    await db.insert('settings', {'key': 'pass_2597', 'value': 'prov123'});

    await db.insert('settings', {'key': 'code_8760', 'value': '8760'}); // Centre
    await db.insert('settings', {'key': 'pass_8760', 'value': 'center123'});

    await db.insert('settings', {'key': 'data_locked', 'value': '0'});
  }
}
