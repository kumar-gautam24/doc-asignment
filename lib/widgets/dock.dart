import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/dock_item.dart';
import 'dock_icon.dart';

class Dock extends StatefulWidget {
  const Dock({
    super.key,
    required this.items,
    this.baseItemSize = 48,
    this.hoveredItemSize = 70,
    this.nonHoveredItemSize = 60,
    this.baseTranslationY = 0.0,
  });

  final List<DockItem> items;
  final double baseItemSize;
  final double hoveredItemSize;
  final double nonHoveredItemSize;
  final double baseTranslationY;

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  late List<DockItem> _items;
  int? hoveredIndex;
  int? draggedIndex;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items); // Initialize items list
  }

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic width for dock
    final dockWidth =
        _items.length * widget.baseItemSize + (_items.length - 1) * 40;

    return Container(
      height: 150,
      width: dockWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black26,
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_items.length, (index) {
          final isDragged = draggedIndex == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isDragged ? 0 : getScaledSize(index),
            height: getScaledSize(index),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            transform: Matrix4.identity()
              ..translate(
                0.0,
                getTranslationY(index),
              ),
            child: Draggable<int>(
              data: index,
              onDragStarted: () => setState(() => draggedIndex = index),
              onDragEnd: (_) => setState(() {
                draggedIndex = null;
                hoveredIndex = null; // Reset hover state
              }),
              onDragCompleted: () => setState(() => draggedIndex = null),
              feedback: Material(
                color: Colors.transparent,
                child: DockIcon(
                  item: _items[index],
                  isDragging: true,
                ),
              ),
              childWhenDragging: const SizedBox(), // Hide dragged item
              child: DragTarget<int>(
                onWillAccept: (data) => data != index,
                onAcceptWithDetails: (details) {
                  final fromIndex = details.data!;
                  _onItemDropped(fromIndex, index);
                },
                onLeave: (_) => setState(() => hoveredIndex = null),
                builder: (context, candidateData, rejectedData) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => hoveredIndex = index),
                    onExit: (_) => setState(() => hoveredIndex = null),
                    child: DockIcon(
                      item: _items[index],
                      isHovered: hoveredIndex == index,
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  void _onItemDropped(int fromIndex, int toIndex) {
    setState(() {
      final draggedItem = _items.removeAt(fromIndex);
      _items.insert(toIndex, draggedItem);
    });
  }

  double getScaledSize(int index) {
    return getPropertyValue(
      index: index,
      baseValue: widget.baseItemSize,
      maxValue: widget.hoveredItemSize,
      nonHoveredMaxValue: widget.nonHoveredItemSize,
    );
  }

  double getTranslationY(int index) {
    return getPropertyValue(
      index: index,
      baseValue: widget.baseTranslationY,
      maxValue: -22,
      nonHoveredMaxValue: -14,
    );
  }

  double getPropertyValue({
    required int index,
    required double baseValue,
    required double maxValue,
    required double nonHoveredMaxValue,
  }) {
    if (hoveredIndex == null) return baseValue;

    final difference = (hoveredIndex! - index).abs();
    const maxAffectedItems = 2;

    if (difference == 0) return maxValue;

    if (difference <= maxAffectedItems) {
      final ratio = (maxAffectedItems - difference) / maxAffectedItems;
      return lerpDouble(baseValue, nonHoveredMaxValue, ratio)!;
    }

    return baseValue;
  }
}
