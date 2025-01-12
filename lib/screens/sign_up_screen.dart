import 'package:taskly_uor/common/color_extension.dart';
import 'package:taskly_uor/repositories/user_repository.dart';
import 'package:taskly_uor/screens/otp_screen.dart';
import 'package:taskly_uor/screens/sign_in_screen.dart';
import 'package:taskly_uor/widgets/round_button.dart';
import 'package:taskly_uor/widgets/round_button_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controladores para capturar os dados inseridos pelo usuário
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? completeNumber; 
  bool isLoading = false;
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
                "assets/images/logo.png",
                width: context.width * 0.60,
              ),
              const SizedBox(height: 20),
               Text(
                "Crie uma conta para continuar",
                style: TextStyle(
                  color: ThemeColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Image.asset("assets/images/message.png",), 
                  labelText: "Name",
                  labelStyle:  TextStyle(color: ThemeColor.primaryText),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)), // Borda branca com transparência
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)), // Borda branca com transparência
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style:  TextStyle(color: ThemeColor.primaryText),
              ),
              
              const SizedBox(height: 20),
              
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                 prefixIcon: Image.asset("assets/images/password.png",),
                  labelText: "Senha",
                  labelStyle: TextStyle(color: ThemeColor.primaryText),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)), // Borda branca com transparência
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)), // Borda branca com transparência
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: ThemeColor.primaryText),
              ),
              
              const SizedBox(height: 20),
              
              TextField(
                controller: _confirmPasswordController,
                obscureText: true, // Esconde o texto digitado
                decoration: InputDecoration(
                  prefixIcon: Image.asset("assets/images/password.png"), // Ícone de cadeado
                  labelText: "Confirmar Senha",
                  labelStyle: TextStyle(color: ThemeColor.primaryText),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)), // Borda branca com transparência
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)), // Borda branca com transparência
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: ThemeColor.primaryText), 
              ),
              
               const SizedBox(height: 20),
              IntlPhoneField(
                controller: _phoneController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: ThemeColor.primaryText), 
                  labelText: 'Número de Contato',
                  labelStyle: TextStyle(color: ThemeColor.primaryText),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)), 
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.primaryText.withOpacity(0.1)), 
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                initialCountryCode: 'AO',
                onChanged: (phone) {
                  completeNumber = phone.completeNumber;
                },
                style:  TextStyle(color: ThemeColor.primaryText), 
                dropdownTextStyle: TextStyle(color: ThemeColor.primaryText), 
              ),
              
              const SizedBox(height: 40),

            isLoading ? 
            const RoundButtonCircularProgress()
            : 
            RoundButton(
              title: "CONTINUAR",
              onPressed: () async {


                // UserRepository userRepository = UserRepository();

                //   Map<String, dynamic> user = {
                //     'username': 'Cesaltino Felix',
                //     'password': '123456',
                //   };

                //   int userId = await userRepository.createUser(user);
                //   // Map<String, dynamic>? dados = await userRepository.getUserById(1);
                //   List<Map<String, dynamic>>? dados = await userRepository.getUsers();
                //   print('Dados>>>>>>>>: \n $dados');

                setState((){
                  isLoading = true;
                });
                String name = _nameController.text;
                String password = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;

                if (password == confirmPassword) {
                  Future.delayed(const Duration(seconds: 3), () {
                    setState((){
                    isLoading = false;
                    });
                    Get.to(
                      OTPScreen( name: name, number: completeNumber, password: password,), 
                      transition: Transition.rightToLeft, duration: const Duration(seconds: 1)
                      );
                    }
                  );
                } else {
                  Get.snackbar(
                    "Erro",
                 "As senhas não coincidem!",
                    backgroundColor: Colors.red,
                    colorText: ThemeColor.primaryText,
                  );
                }
              },
            ),

              const SizedBox(height: 20),
              
              Row(
                children: [
                   Text(
                     "Já tem uma conta?",
                      style: TextStyle(
                        color: ThemeColor.primaryText,
                        fontSize: 14,
                      ),
                    ),
                  TextButton(
                    onPressed: () {
                       Get.to(
                      const SignInScreen(), 
                      transition: Transition.rightToLeft, duration: const Duration(seconds: 1)
                      );
                    },
                    child: Text(
                      "Sign in",
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
}

UserRepository userRepository = UserRepository();

void createUser() async {
  Map<String, dynamic> user = {
    'name': 'Alice',
    'email': 'alice@example.com',
    'password': '1234',
  };

  int userId = await userRepository.createUser(user);
  print('Usuário criado com ID: $userId');
}