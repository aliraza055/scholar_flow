import 'package:flutter/material.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouters.appOnboarding,
      onGenerateRoute: AppRouters.generateRoute,
    );
  }
}
