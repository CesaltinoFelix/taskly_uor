import 'package:flutter/material.dart';

class ThemeColor {
  // Main Colors (Ajuste com opacidade FF para 100% opacidade)
  static Color get primary => const Color(0xFFFFFFFF);  // Azul escuro
  static Color get secondary => const Color(0xFFD64F10); // Amarelo
  static Color get accent => const Color(0xFF007AFF);    // Azul claro

  // Text Colors
  static Color get primaryText => const Color(0xFF818181);// Preto
  static Color get primaryTextWhite  => const Color(0xFFFFFFFF); // Branco
  static Color get  secondaryText =>  const Color(0xFF000000);   // Cinza
  static Color get accentText => const Color.fromARGB(255, 170, 169, 169);      // Azul de destaque

  // Background Colors
  static Color get bgSecondary => Colors.white; // Fundo branco
}

extension AppContext on BuildContext {
  Size get size => MediaQuery.of(this).size; // Obtém o tamanho da tela
  // double get width => size.width;            // Obtém a largura da tela
  // double get height => size.height;          // Obtém a altura da tela

  Future push(Widget widget) async{
    return Navigator.push(this, MaterialPageRoute(builder: (context) => widget));
  }

  void pop() async{
    return Navigator.pop(this);
  }
}
