import 'package:sqflite/sqflite.dart';
import 'package:taskly_uor/services/database_service.dart';
class UserRepository {


  // Função para criar um novo usuário
  Future<int> createUser(Map<String, dynamic> user) async {
    final Database db = await DatabaseService.getDatabase();
    return await db.insert('users', user);
  }

  // Função para obter todos os usuários
  Future<List<Map<String, dynamic>>> getUsers() async {
    final Database db = await DatabaseService.getDatabase();
    return await db.query('users');
  }

  // Função para obter um usuário pelo ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final Database db = await DatabaseService.getDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Função para atualizar um usuário
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final Database db = await DatabaseService.getDatabase();
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Função para excluir um usuário
  Future<int> deleteUser(int id) async {
    final Database db = await DatabaseService.getDatabase();
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
