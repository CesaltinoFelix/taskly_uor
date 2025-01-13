import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly_uor/common/color_extension.dart';
import 'package:taskly_uor/repositories/task_repository.dart';
import 'package:taskly_uor/widgets/round_button.dart';
import 'package:taskly_uor/widgets/round_button_circular_progress.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                "assets/images/logo.png",  // Logo da aplicação
                width: context.width * 0.60,
              ),
              const SizedBox(height: 20),
              Text(
                "Crie uma nova tarefa",
                style: TextStyle(
                  color: ThemeColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Título da tarefa
              TextField(
                controller: _taskTitleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title, color: ThemeColor.primaryText),
                  labelText: "Título da Tarefa",
                  labelStyle: TextStyle(color: ThemeColor.primaryText),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(color: ThemeColor.primaryText),
              ),

              const SizedBox(height: 20),

              // Descrição da tarefa
              TextField(
                controller: _taskDescriptionController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description, color: ThemeColor.primaryText),
                  labelText: "Descrição",
                  labelStyle: TextStyle(color: ThemeColor.primaryText),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(color: ThemeColor.primaryText),
                maxLines: 5,  // Permite várias linhas para a descrição
              ),

              const SizedBox(height: 40),

              // Botão de criação de tarefa
              _isLoading
                  ? const RoundButtonCircularProgress()
                  : RoundButton(
                      title: "CRIAR TAREFA",
                      onPressed: () async {
                        String taskTitle = _taskTitleController.text;
                        String taskDescription = _taskDescriptionController.text;

                        // Validações para garantir que os campos não estão vazios
                        if (taskTitle.isEmpty || taskDescription.isEmpty) {
                          Get.snackbar(
                            "Erro",
                            "Por favor, preencha todos os campos.",
                            backgroundColor: Colors.red,
                            colorText: ThemeColor.primary,
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        // Aqui você pode adicionar a lógica para criar a tarefa
                        bool success = await createTask({
                          'title': taskTitle,
                          'description': taskDescription,
                        });

                        setState(() {
                          _isLoading = false;
                        });

                        if (success) {
                          Get.snackbar(
                            "Sucesso",
                            "Tarefa criada com sucesso!",
                            backgroundColor: Colors.green,
                            colorText: ThemeColor.primary,
                          );
                          // Navegar para outra tela ou mostrar a lista de tarefas
                        }
                      },
                    ),

              const SizedBox(height: 20),

              // Link para navegar de volta à tela de tarefas
              Row(
                children: [
                  Text(
                    "Já tem tarefas criadas?",
                    style: TextStyle(
                      color: ThemeColor.primaryText,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegar para a tela de tarefas
                    },
                    child: Text(
                      "Ver tarefas",
                      style: TextStyle(
                        color: ThemeColor.secondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  TaskRepository taskRepository = TaskRepository();
  Future<bool> createTask(Map<String, dynamic> task) async {
       if (task['title'] == null || task['title'] == '') {
      Get.snackbar(
        "Erro",
        "O título da tarefa é obrigatório.",
        backgroundColor: Colors.red,
        colorText: ThemeColor.primary,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    task['user_id'] = task['user_id'] ?? 'default_user_id';
    task['is_done'] = task['is_done'] ?? false; 
    task['created_at'] = task['created_at'] ?? DateTime.now().toIso8601String();
    task['description'] = task['description'] ?? ''; 

    await taskRepository.createTask(task);
    return true;  
  }
}
