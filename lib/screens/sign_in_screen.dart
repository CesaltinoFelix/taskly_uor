import 'package:taskly_uor/common/color_extension.dart';
import 'package:taskly_uor/screens/home_screen.dart';
import 'package:taskly_uor/screens/sign_up_screen.dart';
import 'package:taskly_uor/widgets/round_button.dart';
import 'package:taskly_uor/widgets/round_button_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
                style:  TextStyle(color: ThemeColor.secondaryText),
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

                        String phone = _phoneController.text;
                        String password = _passwordController.text;

                        try {
                          await Future.delayed(const Duration(seconds: 2));

                          final isAuthenticated = await authenticateUser(phone, password);

                          if (isAuthenticated) {
                            Get.to( HomeScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                          } else {
                            Get.snackbar(
                               "Erro",
                              "Credenciais invalidas",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } catch (e) {
                          Get.snackbar(
                           "Error",
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
   
    return Future.value(true);
  }
}