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
  bool _isPasswordVisible = false; 
  bool _isPasswordConfirmVisible = false; 


  String? completeNumber; 
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  prefixIcon: Icon(Icons.mail, color: ThemeColor.primaryText),
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
  obscureText: !_isPasswordVisible,
  decoration: InputDecoration(
    prefixIcon: Icon(Icons.lock, color: ThemeColor.primaryText),
    labelText: "Senha",
    labelStyle: TextStyle(color: ThemeColor.primaryText),
    suffixIcon: IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: ThemeColor.primaryText,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: ThemeColor.primaryText.withOpacity(0.1),
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: ThemeColor.primaryText.withOpacity(0.1),
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  style: TextStyle(color: ThemeColor.primaryText),
),

              
              const SizedBox(height: 20),
              
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordConfirmVisible, 
                
                decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: ThemeColor.primaryText),
                 suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordConfirmVisible ? Icons.visibility : Icons.visibility_off,
                    color: ThemeColor.primaryText,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
                    });
                  },
                ),
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
                String name = _nameController.text;
                String password = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;

                 if (name.isEmpty || password.isEmpty || completeNumber == null || completeNumber!.isEmpty) {
                  Get.snackbar(
                    "Erro",
                    "Por favor, preencha todos os campos.",
                    backgroundColor: Colors.red,
                    colorText: ThemeColor.primary,
                  );
                  return;
                }

                if (password.length < 8) {
                Get.snackbar(
                  "Erro",
                  "A senha deve ter pelo menos 8 caracteres.",
                  backgroundColor: Colors.red,
                  colorText: ThemeColor.primary,
                );
                return;
              }


                if (password != confirmPassword) {
                  Get.snackbar("Erro", "As senhas não coincidem!",
                      backgroundColor: Colors.red,
                      colorText: ThemeColor.primary);
                  return;
                }

                setState(() => isLoading = true);

                Map<String, dynamic> user = {
                  'username': name,
                  'contact': completeNumber,
                  'password': password,
                };

                bool success = await createUser(user);

                setState(() => isLoading = false);

                if (success) {
                  Get.to(SignInScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(seconds: 1));
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

Future <bool> createUser(Map<String, dynamic> user) async {
  String? contact = user['contact'];

  // Verificar se o número já existe no banco de dados
  bool exists = await userRepository.checkUserExistsByContact(contact!);

  if (exists) {
    Get.snackbar(
      "Erro",
      "Número de telefone já cadastrado!",
      backgroundColor: Colors.red,
      colorText: ThemeColor.primary,
    );
    return (false);
  } else {
    int userId = await userRepository.createUser(user);
    Get.snackbar(
      "Sucesso",
      "Usuário criado com sucesso!",
      backgroundColor: Colors.green,
      colorText: ThemeColor.primary,
    );
    return (true);
  }
}
