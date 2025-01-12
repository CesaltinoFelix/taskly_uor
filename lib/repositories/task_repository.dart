import 'package:taskly_uor/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Para buscar o caminho do banco de dados

class TaskRepository {


  // Função para criar uma nova tarefa
  Future<int> createTask(Map<String, dynamic> task) async {
    final db = await DatabaseService.getDatabase();
    return await db.insert('tasks', task);
  }

  // Função para obter todas as tarefas
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await DatabaseService.getDatabase();
    return await db.query('tasks');
  }

  // Função para obter uma tarefa pelo ID
  Future<Map<String, dynamic>?> getTaskById(int id) async {
    final db = await DatabaseService.getDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Função para atualizar uma tarefa
  Future<int> updateTask(int id, Map<String, dynamic> task) async {
    final db = await DatabaseService.getDatabase();
    return await db.update(
      'tasks',
      task,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Função para excluir uma tarefa
  Future<int> deleteTask(int id) async {
    final db = await DatabaseService.getDatabase();
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
