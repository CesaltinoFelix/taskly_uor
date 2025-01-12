import 'package:flutter/material.dart';
import 'package:taskly_uor/common/color_extension.dart';

class HomeScreen extends StatelessWidget {
  final List<Task> tasks = [
    Task('Comprar mantimentos', '10:00 - 11:00', 'Ir ao supermercado'),
    Task('Reunião de trabalho', '12:00 - 13:00', 'Videoconferência com a equipe'),
    Task('Exercícios', '18:00 - 19:00', 'Caminhada no parque'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas'),
        backgroundColor: ThemeColor.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text(
                  tasks[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(
                  '${tasks[index].time}\n${tasks[index].description}',
                  style: TextStyle(color: Colors.black54),
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
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
    );
  }
}

class Task {
  final String title;
  final String time;
  final String description;

  Task(this.title, this.time, this.description);
}
