import 'package:flutter/material.dart';
import 'package:taskly_uor/common/color_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly_uor/screens/sign_in_screen.dart';
import 'package:taskly_uor/repositories/task_repository.dart'; 
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
    loadedTasks.forEach((task) {
      print('Task ID: ${task['id']}, Title: ${task['title']}, Done: ${task['is_done']}, data: ${task['created_at']} ');
    });
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
      userPhone = prefs.getString('contact') ?? "Usuário";  // Atribui "Usuário" se userPhone for nulo
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

  void _navigateToAddTaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskCreateScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: ThemeColor.secondary,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout, 
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Bem-vindo(a), \n${userPhone ?? 'Usuário'}!",  // Verificação de nulo antes de imprimir
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        task['is_done'] == 1 ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task['is_done'] == 1 ? Colors.green : Colors.grey,
                        size: 36,
                      ),
                      title: Text(
                        task['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['time'],
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task['description'],
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) {
                          if (action == 'edit') {
                            
                          } else if (action == 'delete') {
                            _deleteTask(task['id']);
                          } else if (action == 'mark_done') {
                            _markAsDone(task['id']); 
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'edit', child: Text('Editar')),
                          PopupMenuItem(value: 'delete', child: Text('Excluir')),
                          PopupMenuItem(value: 'mark_done', child: Text('Concluir')),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Análises',
          ),
        ],
        selectedItemColor: ThemeColor.secondary,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: const Icon(Icons.add),
        backgroundColor: ThemeColor.secondary,
      ),
    );
  }
}
