import 'package:flutter/material.dart';

import '../../../../../Core/Theme/app_palette.dart';

Widget buildInfoChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppPalette.offWhite,
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[700],
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          label,
          style:
          TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w400),
        )
      ],
    ),
  );
}