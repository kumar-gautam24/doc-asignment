import 'package:flutter/material.dart';

/// Represents a single item in the dock.
class DockItem {
  DockItem({required this.icon, required this.name});

  /// The item's icon.
  final IconData icon;

  /// The item's name.
  final String name;
}
