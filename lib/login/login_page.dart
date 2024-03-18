import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? kullaniciAdi;
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
     body: Column(
       children: [
         Text("Kullanıcı Adı"),

         Flexible(
           child: Padding(
             padding: const EdgeInsets.all(12.0),
             child: Text(
               kullaniciAdi ?? "Arıza Tipi",
               textAlign: TextAlign.center,
               style: TextStyle(color: Colors.black),
               softWrap: true,
             ),
           ),
         ),


       ],
     )
    );
  }
}
