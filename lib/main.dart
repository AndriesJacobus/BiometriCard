import 'package:biometricard/services/service_driver.dart';
import 'package:flutter/material.dart';
import 'package:biometricard/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start app services
  await setupServices();

  // Start app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
      ),
      home: const MyHomePage(
        title: "Secure Cards",
      ),
    );
  }
}
