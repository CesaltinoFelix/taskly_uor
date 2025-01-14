import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly_uor/repositories/task_repository.dart';
import 'package:taskly_uor/screens/sign_in_screen.dart';
import 'package:taskly_uor/screens/task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final loadedTasks = await _taskRepository.getTasks();
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

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void _goToCreateTaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskCreateScreen()),
    ).then((_) => _loadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(
            Icons.menu,
            color: Colors.black87,
          ),
        ),
        title: const Text(
          'Minhas tarefas',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.black87,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.black87,
            onPressed: _logout,
          ),
        ],
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
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0 || task['created_at'] != tasks[index - 1]['created_at'])
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                task['created_at'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          _buildTaskCard(
            taskId: task['id'], // Passa o taskId corretamente
            title: task['title'],
            description: task['description'],
            time: "12h",
            isDone: task['is_done'] == 1,
            onDelete: () => _deleteTask(task['id']),
            onMarkDone: () => _markAsDone(task['id']),
          ),
        ],
      );
    },
  ),
)
,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateTaskScreen,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: '',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
      ),
    );
  }

Widget _buildTaskCard({
  required int taskId,  // Alterado para receber o ID como parâmetro
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
              color: isDone ? Colors.green : Colors.orange,
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
                  _showUnmarkDialog(taskId); // Agora passa o taskId correto
                } else {
                  onMarkDone(); // Marca como concluída
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
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
              Navigator.of(context).pop(); // Fecha o diálogo sem fazer nada
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
              _unmarkAsDone(taskId); // Executa a ação de desconcluir
            },
            child: const Text(
              'Sim',
              style: TextStyle(color: Colors.orange),
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