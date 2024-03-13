import 'package:flutter/material.dart';

class UploadTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? errorText; // Tambahkan errorText

  const UploadTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.errorText, // Inisialisasi errorText dalam konstruktor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontFamily: 'ErasBoldItc'),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          errorText: errorText,
          errorStyle: const TextStyle(
              fontSize: 12, color: Colors.red, fontFamily: 'ErasBoldItc'),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red))),
    );
  }
}
