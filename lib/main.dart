
import 'package:file_pod/pages/home/home_page.dart';
import 'package:file_pod/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
      child: const MaterialApp(
        title: "FilePod",
        debugShowCheckedModeBanner: false,
        home: HomePage()
      ),
    );
  }
}
