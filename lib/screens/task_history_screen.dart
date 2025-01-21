import 'package:flutter/material.dart';
import 'package:taskly_uor/common/color_extension.dart';
import 'package:intl/intl.dart';
import 'package:taskly_uor/repositories/task_repository.dart';
import 'package:taskly_uor/screens/Task_statistics_screen.dart';
import 'package:taskly_uor/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TaskRegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskHistoryScreen(),
    );
  }
}

class TaskHistoryScreen extends StatefulWidget {
  @override
  _TaskHistoryScreenState createState() => _TaskHistoryScreenState();
}

class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
      List<Map<String, dynamic>> tasks = [];
  final TaskRepository _taskRepository = TaskRepository();
  String? userPhone = '';


  @override
  void initState() {
    super.initState();
    _getUserData();
    _loadTasks();
  }
void _loadTasks() async {
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
}

  void _markAsDone(int taskId) async {
    await _taskRepository.markTaskAsDone(taskId);
    _loadTasks();
  }

  void _deleteTask(int taskId) async {
    await _taskRepository.deleteTask(taskId);
    _loadTasks();
  }

  void _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhone = prefs.getString('contact') ?? "Usuário";
    });
  }

String formatTaskTime(dynamic time) {
  if (time == null || time is String && time.isEmpty) {
    return 'Sem data definida';
  }
  
  DateTime parsedDate = DateTime.tryParse(time) ?? DateTime.now();
  
  return DateFormat('dd/MM/yyyy').format(parsedDate);
}


String formatTaskCreationDate(String createdAt) {
  final DateTime createdDate = DateTime.parse(createdAt);
  final DateTime now = DateTime.now();

  final Duration difference = now.difference(createdDate);

  if (difference.inDays == 0) {
    return 'Hoje';
  } else if (difference.inDays == 1) {
    return 'Ontem';
  } else if (difference.inDays == 2) {
    return 'Antes de ontem';
  } else {
    return 'Há ${difference.inDays} dias';
  }
}

  
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskStatisticsScreen(),
          ),
        );
      }
    });
  }

Color _getSelectedItemColor(int index) {
  if (_currentIndex == index) {
    return ThemeColor.secondary; // Cor do item selecionado
  } else {
    return Colors.grey; // Cor do item não selecionado
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico de Tarefas',
          style: TextStyle(
            color: ThemeColor.secondary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: ThemeColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo(a), Usuário!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
  child: ListView.builder(
    itemCount: tasks.where((task) => task['is_done'] == 1).length,
    itemBuilder: (context, index) {
      // Filtra apenas tarefas não concluídas
      final filteredTasks = tasks.where((task) => task['is_done'] == 1).toList();
      final task = filteredTasks[index];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0 || task['created_at'] != filteredTasks[index - 1]['created_at'])
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                formatTaskCreationDate(task['created_at']),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          _buildTaskCard(
            taskId: task['id'],
            title: task['title'],
            description: task['description'],
            time: formatTaskTime(task['time']),
            isDone: task['is_done'] == 1,
            onDelete: () => _deleteTask(task['id']),
            onMarkDone: () => _markAsDone(task['id']),
          ),
        ],
      );
    },
  ),
),

  SizedBox(height: 40),
          ],
        ),
      ),
     
      bottomNavigationBar: BottomNavigationBar(
        items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.history, color: _getSelectedItemColor(0)),
          label: 'Histórico',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view, color: _getSelectedItemColor(1)),
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics, color: _getSelectedItemColor(2)),
          label: 'Estatísticas',
        ),
      ],
        currentIndex: _currentIndex,
        selectedItemColor: ThemeColor.secondary,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped
      ),
    );
  }

Widget _buildTaskCard({
  required int taskId,
  required String title,
  required String description,
  required String time,
  required bool isDone,
  required VoidCallback onDelete,
  required VoidCallback onMarkDone,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isDone ? Colors.green.shade100 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDone ? Colors.green : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: isDone ? Colors.green : ThemeColor.secondary,
            ),
            const SizedBox(width: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                isDone ? Icons.undo : Icons.check,
                color: isDone ? Colors.red : Colors.green,
              ),
              onPressed: () {
                if (isDone) {
                  _showUnmarkDialog(taskId);
                } else {
                  onMarkDone();
                }
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.delete, color: Colors.red),
            //   onPressed: onDelete,
            // ),
          ],
        ),
      ],
    ),
  );
}

void _showUnmarkDialog(int taskId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Desconcluir Tarefa'),
        content: const Text('Tem certeza que deseja desconcluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _unmarkAsDone(taskId);
            },
            child:  Text(
              'Sim',
              style: TextStyle(color: ThemeColor.secondary),
            ),
          ),
        ],
      );
    },
  );
}

void _unmarkAsDone(int taskId) async {
  await _taskRepository.markTaskAsUndone(taskId);

  setState(() {
    tasks = tasks.map((task) {
      if (task['id'] == taskId) {
        task['is_done'] = 0; 
      }
      return task;
    }).toList(); 
  });
}


}