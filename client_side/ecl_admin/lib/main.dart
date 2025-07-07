import 'package:flutter/material.dart';
import 'package:ecl_admin/screens/admin_main.dart'; // ✅ use this instead

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Job Panel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainLayout(), // ✅ bottom nav with 2 pages
    );
  }
}
