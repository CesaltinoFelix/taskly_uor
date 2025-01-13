import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  // Função para inicializar o banco de dados
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Caminho do banco de dados
    final String path = join(await getDatabasesPath(), 'taskly_uor.db');

    // Criação e atualização do banco de dados
    _database = await openDatabase(
      path,
      version: 2, // Atualize a versão do banco
      onCreate: (Database db, int version) async {
        // Criação da tabela de usuários
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            contact TEXT,
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
            created_at TEXT,
            FOREIGN KEY(user_id) REFERENCES users(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Adiciona as colunas 'created_at' e 'contact' nas tabelas 'tasks' e 'users', respectivamente, caso a versão seja atualizada
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN contact TEXT');
          await db.execute('ALTER TABLE tasks ADD COLUMN created_at TEXT');
        }
      },
    );

    return _database!;
  }
}
