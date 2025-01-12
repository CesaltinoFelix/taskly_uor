import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  // Função para inicializar o banco de dados
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Caminho do banco de dados
    final String path = join(await getDatabasesPath(), 'taskly_uor.db');
    
    // Criação do banco de dados
    _database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      // Criação da tabela de usuários
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          password TEXT
        )
      ''');

      // Criação da tabela de tarefas
      await db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          title TEXT,
          description TEXT,
          is_done INTEGER,
          FOREIGN KEY(user_id) REFERENCES users(id)
        )
      ''');
    });
    return _database!;
  }
}
