import 'package:taskly_uor/services/database_service.dart';

class TaskRepository {

  // Função para criar uma nova tarefa
  Future<int> createTask(Map<String, dynamic> task) async {
    try {
      final db = await DatabaseService.getDatabase();
      return await db.insert('tasks', task);
    } catch (e) {
      // Handle exceptions, you can log or print the error
      rethrow;
    }
  }

  // Função para obter todas as tarefas
  Future<List<Map<String, dynamic>>> getTasks() async {
    try {
      final db = await DatabaseService.getDatabase();
      return await db.query('tasks');
    } catch (e) {
      rethrow;
    }
  }

  // Função para obter uma tarefa pelo ID
  Future<Map<String, dynamic>?> getTaskById(int id) async {
    try {
      final db = await DatabaseService.getDatabase();
      List<Map<String, dynamic>> result = await db.query(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      rethrow;
    }
  }

  // Função para atualizar uma tarefa
  Future<int> updateTask(int id, Map<String, dynamic> task) async {
    try {
      final db = await DatabaseService.getDatabase();
      return await db.update(
        'tasks',
        task,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Função para excluir uma tarefa
  Future<int> deleteTask(int id) async {
    try {
      final db = await DatabaseService.getDatabase();
      return await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Função para marcar uma tarefa como concluída
  Future<int> markTaskAsDone(int id) async {
    try {
      final db = await DatabaseService.getDatabase();
      return await db.update(
        'tasks',
        {'is_done': 1}, // 1 significa "concluída"
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> markTaskAsUndone(int id) async {
    try {
      final db = await DatabaseService.getDatabase();
      return await db.update(
        'tasks',
        {'is_done': 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Função para obter tarefas concluídas
  Future<List<Map<String, dynamic>>> getCompletedTasks() async {
    try {
      final db = await DatabaseService.getDatabase();
      return await db.query(
        'tasks',
        where: 'is_done = ?',
        whereArgs: [1], // 1 para "concluídas"
      );
    } catch (e) {
      rethrow;
    }
  }

  // Função para obter tarefas não concluídas
  Future<List<Map<String, dynamic>>> getPendingTasks() async {
    try {
      final db = await DatabaseService.getDatabase();
      return await db.query(
        'tasks',
        where: 'is_done = ?',
        whereArgs: [0], // 0 para "não concluídas"
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllTasks() async {
    final db = await DatabaseService.getDatabase();

    try {
      // Comando SQL para deletar todas as tarefas
      await db.delete('tasks');
      print("Todas as tarefas foram excluídas com sucesso.");
    } catch (e) {
      print("Erro ao excluir tarefas: $e");
    }
  }

  Future<int?> getUserIdByContact(String contact) async {
  final db = await DatabaseService.getDatabase(); // Assuma que o método para abrir o DB já existe
  final result = await db.query(
    'users',
    columns: ['id'],
    where: 'contact = ?',
    whereArgs: [contact],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['id'] as int;
  }
  return null;
}

Future<List<Map<String, dynamic>>> getTasksByUserId(int userId) async {
  final db = await  DatabaseService.getDatabase(); 
  final result = await db.query(
    'tasks',
    where: 'user_id = ?',
    whereArgs: [userId],
  );
  return result;
}

}
