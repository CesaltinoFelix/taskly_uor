import 'package:taskly_uor/common/color_extension.dart';
import 'package:taskly_uor/screens/sign_in_screen.dart';
import 'package:taskly_uor/screens/sign_up_screen.dart';
import 'package:taskly_uor/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(), // Espaço para centralizar o logo
              // Logo centralizado
              Image.asset(
                "assets/images/logo.png",
                width: context.width * 0.60,
              ),
              const SizedBox(height: 100), // Maior espaço entre o logo e os botões
              // Botões de login com Google, Facebook e Email
              _buildSocialButton("assets/images/logos_google-icon.png", "Login usando Google", () {
                // Lógica para login com Google
              }),
              const SizedBox(height: 25),
              _buildSocialButton("assets/images/logos_facebook.png", "Login usando Facebook", () {
                // Lógica para login com Facebook
              }),
              const SizedBox(height: 25),
              _buildSocialButton("assets/images/logos_google-gmail.png", "Login usando Email", () {
                // Lógica para login com Email
              }),
              const SizedBox(height: 50),
              // Divisor com "ou"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "OU",
                      style: TextStyle(
                        color: ThemeColor.primaryTextWhite,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // Botão de Login
              RoundButton(
                title: "SIGN IN",
                onPressed: () {
                 Get.to(()=> const SignInScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                },
              ),

              const SizedBox(height: 10),
              
              TextButton(
                onPressed: () {
                 Get.to(()=> const SignUpScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                },
                child: Text(
                "SIGN UP",
                style: TextStyle(
                  color: ThemeColor.secondary,
                  fontSize: 16,
                ),
              ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                  "Esqueceu a senha?",
                  style: TextStyle(
                    color: ThemeColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
                  TextButton(
                onPressed: () {
                  // Lógica para redirecionar à tela de redefinição de senha
                },
                child: Text(
                  "Mudar senha",
                  style: TextStyle(
                    color: ThemeColor.accentText,
                    fontSize: 14,
                  ),
                ),
              ),
                ],
              ),
              const Spacer(), // Espaço final para melhor centralização
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir os botões de login social
  Widget _buildSocialButton(String iconPath, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          iconPath,
          width: 30,
          height: 30,
        ),
        label: Text(
          label,
          style: TextStyle(color: ThemeColor.primaryText),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: ThemeColor.accentText), // Borda branca
          padding: const EdgeInsets.symmetric(vertical: 14), // Aumentando o espaçamento interno
          backgroundColor: Colors.transparent, // Fundo transparente
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
