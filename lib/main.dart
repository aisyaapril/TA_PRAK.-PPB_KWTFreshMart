import 'package:flutter/material.dart';
import 'widget/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KWT Freshmart',
      debugShowCheckedModeBanner: false,
      home: const NavigationPage(), // Memanggil halaman utama dengan navigasi
    );
  }
}
