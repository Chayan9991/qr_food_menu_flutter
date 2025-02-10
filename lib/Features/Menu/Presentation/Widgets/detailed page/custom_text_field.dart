import 'package:flutter/material.dart';

import '../../../../../Core/Theme/app_palette.dart';

Widget customTextField(TextEditingController textController) {
  // if (addedInstruction != null) {
  //   textController.text = addedInstruction;
  // }
  return TextField(
    maxLines: 3,
    maxLength: 500,
    controller: textController,
    style: const TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w400,
    ),
    decoration: InputDecoration(
      hintText: "Add order instructions...",
      hintStyle: TextStyle(
          color: Colors.grey.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.w500),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.teal, width: 2.0),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: AppPalette.offWhite,
      filled: true,
    ),
  );
}
