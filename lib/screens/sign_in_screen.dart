import 'package:taskly_uor/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:taskly_uor/common/color_extension.dart';
import 'package:taskly_uor/screens/sign_up_screen.dart';
import 'package:taskly_uor/widgets/round_button.dart';
import 'package:taskly_uor/widgets/round_button_circular_progress.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:taskly_uor/repositories/user_repository.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? completeNumber;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Verifica se o usuário já está logado
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contact = prefs.getString('contact');
    
    if (contact != null && contact.isNotEmpty) {
      // Se o usuário já estiver logado, redireciona para a HomeScreen
      Get.to(HomeScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
    }
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
              Image.asset(
                "assets/images/logo.png",
                width: context.width * 0.60,
              ),
              const SizedBox(height: 20),
              const Text(
                "Entrar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              IntlPhoneField(
                controller: _phoneController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: ThemeColor.primaryText),
                  labelText: 'Número de Telefone',
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
                style: TextStyle(color: ThemeColor.secondaryText),
                dropdownTextStyle: TextStyle(color: ThemeColor.primaryText),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Image.asset("assets/images/password.png"),
                  labelText: "Senha",
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
                style: TextStyle(color: ThemeColor.secondaryText),
              ),

              const SizedBox(height: 40),

              isLoading
                  ? const RoundButtonCircularProgress()
                  : RoundButton(
                      title: "SIGN IN",
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        String phone = completeNumber ?? '';
                        String password = _passwordController.text;

                        // Validação dos campos
                        if (phone.isEmpty) {
                          Get.snackbar(
                            "Erro",
                            "Por favor, insira um número de telefone.",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }

                        if (password.isEmpty) {
                          Get.snackbar(
                            "Erro",
                            "Por favor, insira a senha.",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }

                        try {
                          // Chamando a função de autenticação
                          bool authenticated = await authenticateUser(phone, password);

                          if (authenticated) {
                            Get.to(HomeScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                          }

                        } catch (e) {
                          Get.snackbar(
                            "Erro",
                            "Ocorreu um erro. Por favor, tente novamente mais tarde.",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),

              const SizedBox(height: 20),

              Row(
                children: [
                   Text(
                    "Não tem uma conta?",
                    style: TextStyle(
                      color: ThemeColor.primaryText,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(SignUpScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                    },
                    child: Text(
                    "Criar conta",
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

  Future<bool> authenticateUser(String phone, String password) async {
    UserRepository userRepository = UserRepository();
    
    bool userExists = await userRepository.checkUserExistsByContact(phone);
    
    if (!userExists) {
      Get.snackbar(
        "Erro",
        "Usuário não encontrado!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    bool passwordMatches = await userRepository.checkUserPassword(phone, password);

    if (!passwordMatches) {
      Get.snackbar(
        "Erro",
        "Senha incorreta!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Salva o número de telefone no SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('contact', phone);
    
    return true;
  }
}
