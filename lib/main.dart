import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_card_screen.dart';
import 'screens/card_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Card App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/addCard': (context) => AddCardScreen(),
        '/cardDetails': (context) => CardDetailsScreen(),
      },
    );
  }
}
