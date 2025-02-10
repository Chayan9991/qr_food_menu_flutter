import 'package:flutter/material.dart';

Widget buildVegNonVegIcon(bool isVeg) {
  return Container(
    height: 15, // Increased size for better visibility
    width: 15,
    decoration: BoxDecoration(
      color: Colors.white, // Contrasting background
      border: Border.all(
        color: isVeg ? Colors.green : Colors.red,
        width: 2,
      ),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Subtle shadow for contrast
          blurRadius: 4,
          offset: Offset(1, 2), // Slight offset for the shadow
        ),
      ],
    ),
    child: Center(
      child: Container(
        height: 7, // Slightly larger inner circle
        width: 7,
        decoration: BoxDecoration(
          color: isVeg ? Colors.green : Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}
