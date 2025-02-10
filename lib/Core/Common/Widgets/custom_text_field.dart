import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String _hintText;
  final TextEditingController _textController;


  const CustomTextField(
      {super.key,
        required String hintText,

        required TextEditingController textController})
      : _hintText = hintText,

        _textController = textController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey,),
          suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.sort_rounded), color: Colors.grey,),
          hintText: _hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
