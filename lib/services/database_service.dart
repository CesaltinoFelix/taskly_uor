import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  // Função para inicializar o banco de dados
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Caminho do banco de dados
    final String path = join(await getDatabasesPath(), 'taskly_uor.db');

    _database = await openDatabase(
      path,
      version: 4, 
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            contact TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            title TEXT,
            description TEXT,
            is_done INTEGER,
            created_at INTEGER,
            time INTEGER,
            FOREIGN KEY(user_id) REFERENCES users(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN contact TEXT');
        }

        if (oldVersion < 3) {
          var columns = await db.rawQuery("PRAGMA table_info(tasks);");
          bool columnExists = columns.any((column) => column['name'] == 'created_at');
          
          if (!columnExists) {
            await db.execute('ALTER TABLE tasks ADD COLUMN created_at INTEGER');
          }
        }
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE tasks ADD COLUMN time INTEGER');
        }

      },
    );

    return _database!;
  }
}
