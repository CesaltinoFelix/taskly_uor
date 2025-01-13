import 'package:taskly_uor/services/database_service.dart';
class UserRepository {


  // Função para criar um novo usuário
  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await DatabaseService.getDatabase();
    return await db.insert('users', user);
  }

  // Função para obter todos os usuários
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DatabaseService.getDatabase();
    return await db.query('users');
  }

  // Função para obter um usuário pelo ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await DatabaseService.getDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Função para atualizar um usuário
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await DatabaseService.getDatabase();
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Função para excluir um usuário
  Future<int> deleteUser(int id) async {
    final db = await DatabaseService.getDatabase();
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> checkUserExistsByContact(String contact) async {
    final db = await DatabaseService.getDatabase();
    final result = await db.query(
      'users',
      where: 'contact = ?',
      whereArgs: [contact],
    );
    return result.isNotEmpty;
  }

  Future<bool> checkUserPassword(String contact, String password) async {
  final db = await DatabaseService.getDatabase();

  final result = await db.query(
    'users',
    where: 'contact = ? AND password = ?',
    whereArgs: [contact, password],
  );

  return result.isNotEmpty;
}

}
