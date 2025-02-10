import 'package:flutter/material.dart';

class MenuCategoryChip extends StatelessWidget {
  final bool isSelected;
  final String item;
  final Gradient? gradient; // Added gradient property

  const MenuCategoryChip({
    super.key,
    required this.isSelected,
    required this.item,
    this.gradient, // Optional gradient for selected state
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: isSelected && gradient != null ? gradient : null,
        color: isSelected && gradient == null
            ? Colors.teal.shade700
            : Colors.white, // Fallback to a solid color if no gradient
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.black26,
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text(
          item,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
