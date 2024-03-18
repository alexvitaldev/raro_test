import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:raro_test/controller/home_controller.dart';
import 'package:raro_test/screens/home_screen.dart';

void main() {
  setUpLocators();
  runApp(const MyApp());
}

void setUpLocators() {
  GetIt.I.registerSingleton(HomeController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(title: 'Parking'),
    );
  }
}
