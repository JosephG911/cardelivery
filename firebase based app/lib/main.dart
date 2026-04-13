import 'package:blearn/Pages/login.dart';
import 'package:blearn/auth_service.dart';
import 'package:blearn/chome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Med-Car',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purpleAccent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purpleAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: AuthService.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(color: Colors.purpleAccent),
              ),
            );
          }

          if (snapshot.hasData) {
            return const Chome();
          }

          return const LoginPage();
        },
      ),
    );
  }
}