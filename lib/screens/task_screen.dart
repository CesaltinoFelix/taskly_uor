import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatar a data
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly_uor/common/color_extension.dart';
import 'package:taskly_uor/repositories/task_repository.dart';
import 'package:taskly_uor/screens/home_screen.dart';
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
  DateTime? selectedDate;
  bool _isLoading = false;

  // Função para selecionar a data
Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: ThemeColor.secondary, 
          colorScheme: ColorScheme.light(
            primary: ThemeColor.secondary, 
            onPrimary: Colors.white, 
          ),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );
  if (picked != null && picked != selectedDate)
    setState(() {
      selectedDate = picked;
    });
}


  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
                "Criar nova tarefa",
                style: TextStyle(
                  color: ThemeColor.secondary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),

        leading:  Padding(
          padding: EdgeInsets.only(left: 16),
          child: IconButton(
          icon:  Icon(Icons.arrow_back, color:  Colors.black87,),
          onPressed: () {
            Get.to(HomeScreen());
          },
        ),

 
        ),
        backgroundColor: ThemeColor.primary, // Ajuste o fundo conforme necessário
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              const SizedBox(height: 20),
          

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
                maxLines: 5, // Permite várias linhas para a descrição
              ),

              const SizedBox(height: 20),

              // Seletor de data
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: selectedDate == null
                          ? 'Data da Tarefa'
                          : DateFormat('dd/MM/yyyy').format(selectedDate!),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Botão de criação de tarefa
              // Botão de criação de tarefa
_isLoading
    ? const RoundButtonCircularProgress()
    : RoundButton(
        title: "CRIAR TAREFA",
        onPressed: () async {
          String taskTitle = _taskTitleController.text;
          String taskDescription = _taskDescriptionController.text;

          // Validações para garantir que os campos não estão vazios
          if (taskTitle.isEmpty || taskDescription.isEmpty || selectedDate == null) {
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
            'time': selectedDate?.toIso8601String() ?? '',
          });

          setState(() {
            _isLoading = false;
          });

          if (success) {
            // Exibir mensagem de sucesso
            Get.snackbar(
              "Sucesso",
              "Tarefa criada com sucesso!",
              backgroundColor: Colors.green,
              colorText: ThemeColor.primary,
            );

            // Limpar os campos
            _taskTitleController.clear();
            _taskDescriptionController.clear();
            setState(() {
              selectedDate = null;
            });
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
                      Get.to(HomeScreen());
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
    final prefs = await SharedPreferences.getInstance();
    String? userContact = prefs.getString('contact');
    final userId = await taskRepository.getUserIdByContact(userContact!);
    task['user_id'] = task['user_id'] ?? userId;
    task['is_done'] = task['is_done'] ?? 0;
    task['created_at'] = task['created_at'] ?? DateTime.now().toIso8601String();
    task['description'] = task['description'] ?? '';

    await taskRepository.createTask(task);
    return true;
  }
}
