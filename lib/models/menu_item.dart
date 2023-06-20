import 'package:flutter/material.dart';

class MenuItem {
  final String text;
  final String value;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.value,
    required this.icon,
  });

  @override
  String toString() {
    return value;
  }
}
