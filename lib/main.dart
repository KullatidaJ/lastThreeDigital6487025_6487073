import 'package:flutter/material.dart';
import 'package:national_view/Page/Home.dart';
import 'package:national_view/Page/Welcome.dart';
//import 'package:firebase_auth/firebase_auth.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
        
          //primarySwatch: Colors.blue,
          ),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
