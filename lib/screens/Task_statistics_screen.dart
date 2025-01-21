import 'package:flutter/material.dart';
import 'package:taskly_uor/common/color_extension.dart';
import 'package:taskly_uor/repositories/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskStatisticsScreen extends StatefulWidget {
  const TaskStatisticsScreen({Key? key}) : super(key: key);

  @override
  State<TaskStatisticsScreen> createState() => _TaskStatisticsScreenState();
}

class _TaskStatisticsScreenState extends State<TaskStatisticsScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  int totalTasks = 0;
  int completedTasks = 0;
  int pendingTasks = 0;
      List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

void _loadStatistics() async {
  final prefs = await SharedPreferences.getInstance();
  String? userContact = prefs.getString('contact'); // Recupera o contato do usuário logado
  
  if (userContact == null || userContact.isEmpty) {
    setState(() {
      tasks = [];
    });
    return;
  }

  // Obtenha o user_id associado ao contato
  final userId = await _taskRepository.getUserIdByContact(userContact);

  if (userId == null) {
    setState(() {
      tasks = [];
    });
    return;
  }

  // Filtre as tarefas pelo user_id
  final loadedTasks = await _taskRepository.getTasksByUserId(userId);
  setState(() {
    tasks = loadedTasks;
  });
  setState(() {
      totalTasks = tasks.length;
      completedTasks = tasks.where((task) => task['is_done'] == 1).length;
      pendingTasks = totalTasks - completedTasks;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Estatísticas',
          style: TextStyle(
            color: ThemeColor.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColor.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo das tarefas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColor.secondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatisticTile(
              title: 'Total de tarefas',
              value: totalTasks.toString(),
              color: ThemeColor.secondary,
            ),
            _buildStatisticTile(
              title: 'Tarefas concluídas',
              value: completedTasks.toString(),
              color: Colors.green,
            ),
            _buildStatisticTile(
              title: 'Tarefas pendentes',
              value: pendingTasks.toString(),
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            if (totalTasks > 0)
              _buildCompletionChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticTile({
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionChart() {
    final double completionPercentage =
        (completedTasks / totalTasks) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progresso de conclusão',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width * (completionPercentage / 100),
              decoration: BoxDecoration(
                color: ThemeColor.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${completionPercentage.toStringAsFixed(1)}% concluídas',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
