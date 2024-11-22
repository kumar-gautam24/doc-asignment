import 'package:flutter/material.dart';
import 'widgets/dock.dart';
import 'models/dock_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: [
              DockItem(icon: Icons.home, name: 'Home'),
              DockItem(icon: Icons.search, name: 'Search'),
              DockItem(icon: Icons.settings, name: 'Settings'),
              DockItem(icon: Icons.person, name: 'Profile'),
              DockItem(icon: Icons.camera, name: 'Camera'),
            ],
          ),
        ),
      ),
    );
  }
}
