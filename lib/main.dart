import 'package:flutter/material.dart';
import 'package:chatapp/SocketIOChat/Routes.dart';

void main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Routes.routes(),
      initialRoute: Routes.initScreen(),
    );
  }
}
