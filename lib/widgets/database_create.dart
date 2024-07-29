import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE patients(id INTEGER PRIMARY KEY, identity TEXT, expedient TEXT, date_of_attention TEXT, date_of_birth TEXT, birth_weight_kg REAL, birth_weight_lb REAL, sex TEXT, is_older_than_two_months INTEGER, generate_cuit INTEGER, first_name TEXT, second_name TEXT, first_surname TEXT, second_surname TEXT, birth_number TEXT, age_years INTEGER, age_months INTEGER, age_days INTEGER, current_weight_kg REAL, current_weight_lb REAL, height_cm REAL, problem TEXT, cephalic_perimeter TEXT, blood_pressure TEXT, pulse TEXT, oximetry TEXT, temperature REAL, consultation_type TEXT, region TEXT, establishment TEXT)',
    );
  }

  Future<void> insertPatient(Map<String, dynamic> patient) async {
    final db = await database;
    await db.insert(
      'patients',
      patient,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllPatients() async {
    final db = await database;
    return await db.query('patients');
  }

  Future<String> getDatabasePath() async {
    return join(await getDatabasesPath(), 'app_database.db');
  }
}
