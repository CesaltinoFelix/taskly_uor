import 'package:taskly_uor/screens/auth_screen.dart';
import 'package:taskly_uor/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:taskly_uor/common/color_extension.dart';
import 'package:get/get.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.primary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/start.png",
            width: context.width,
            height: context.height,
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: Column(
              children: [
               
                SizedBox(height: context.height * 0.4,),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        Image.asset("assets/images/logo1.png", 
                        width: context.width * 0.6,
                        height: context.height * 0.05,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Organize suas tarefas, simplifique sua vida!\n🌟 Rápido. Simples. Eficaz.",
                          style: TextStyle(
                            color: ThemeColor.accentText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: context.height * 0.20),
                        RoundButton(
                          title: "Vamos começar!", 
                          onPressed: (){
                              Get.to(()=> const AuthScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                          },
                          
                          ),
                        
                        SizedBox(height: context.height * 0.04),
                        
                        GestureDetector(
                          onTap: (){},
                          child: Container(
                            //padding: const EdgeInsets.symmetric(vertical: 0,),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: ThemeColor.accentText, width: 2 
                                ),
                                
                              )
                            ),
                            child: Text(
                              "By UÓR", 
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ThemeColor.accentText)
                              ),
                          )
                          )            
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
