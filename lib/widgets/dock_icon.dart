import 'package:flutter/material.dart';
import '../models/dock_item.dart';

class DockIcon extends StatelessWidget {
  const DockIcon({
    super.key,
    required this.item,
    this.isHovered = false,
    this.isDragging = false,
  });

  final DockItem item;
  final bool isHovered;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    final double size = isDragging || isHovered ? 45.0 : 35.0; // Scale size
    final double fontSize = size / 4; // Adjust font size relative to icon

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon container
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isHovered ? Colors.blueAccent : Colors.blue,
          ),
          child: Icon(
            item.icon,
            color: Colors.white,
            size: size / 2,
          ),
        ),
        const SizedBox(height: 4), // Space between icon and text
        // Text (only when hovered and not dragging)
        if (isHovered && !isDragging)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.name,
              style: TextStyle(fontSize: fontSize, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
