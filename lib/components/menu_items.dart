import 'package:flutter/material.dart';
import 'package:biometricard/models/menu_item.dart';

class MenuItems {
  static const number = MenuItem(
    text: "Copy Card Number",
    value: "number",
    icon: Icons.numbers,
  );
  static const cVV = MenuItem(
    text: "Copy Card CVV",
    value: "cvv",
    icon: Icons.width_normal_rounded,
  );

  static const List<MenuItem> firstItems = [number, cVV];

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
