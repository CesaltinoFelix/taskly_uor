import 'package:taskly_uor/common/color_extension.dart';
import 'package:taskly_uor/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {

  List listArr = [
    "Portugues",
    "English",
    "Chinese",
    "Arabic",
    "French"
  ];

  int selectchange = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
        }, 
        icon: Image.asset(
        "assets/images/Arrow 1.png", 
        width: 15,
        height: 15,)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose Language", 
            style: TextStyle(
              color: ThemeColor.primaryTextWhite,
              fontSize: 25,
              fontWeight: FontWeight.w800
            ),
            ),
            const SizedBox(height: 15,),
            Expanded(child: ListView.builder(
              itemCount: listArr.length,
              itemBuilder: (context, index) {
                return ListTile(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                    selectchange = index;
                      
                    });
                    Get.to(()=> const AuthScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));

                  },
                  title: Text(
                    listArr[index], 
                    style: TextStyle(color: index == selectchange ?ThemeColor.accentText : ThemeColor.primaryTextWhite, fontSize: 16),
                  ),
                  trailing: index == selectchange ? Image.asset("assets/images/yes-icon.png", width: 15,) : null,
                );
              }))          ],
        ),
      ),
    );
  }
}