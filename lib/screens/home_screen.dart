import 'package:flutter/material.dart';

// Modelo de tarefa
class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [
    Task(title: 'Comprar mantimentos'),
    Task(title: 'Estudar Flutter'),
    Task(title: 'Fazer exercício'),
  ];

  // Função para adicionar tarefa
  void _addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
  }

  // Função para marcar tarefa como concluída
  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  // Função para excluir tarefa
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Função para mostrar a caixa de diálogo para adicionar nova tarefa
  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Digite o nome da tarefa'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  _addTask(taskController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Adicionar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly - Gestão de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              tasks[index].title,
              style: TextStyle(
                decoration: tasks[index].isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                tasks[index].isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                color: tasks[index].isCompleted ? Colors.green : null,
              ),
              onPressed: () => _toggleTaskCompletion(index),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTask(index),
            ),
          );
        },
      ),
    );
  }
}
