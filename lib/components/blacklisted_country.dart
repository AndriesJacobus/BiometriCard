import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:flutter/material.dart';
import 'package:biometricard/models/country.dart';
import 'package:biometricard/services/ui_service.dart';

class BlacklistedCountry extends StatefulWidget {
  final Country country;
  final Function removeFromBlacklist;

  const BlacklistedCountry({
    Key? key,
    required this.country,
    required this.removeFromBlacklist,
  }) : super(key: key);

  @override
  State<BlacklistedCountry> createState() => _BlacklistedCountryState();
}

class _BlacklistedCountryState extends State<BlacklistedCountry>
    with SecureStorage {
  Future<void> copyToClipboard(String name, String value) async {
    await uiService.copyValueToClipboard("Card $name", value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.country.name,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        IconButton(
          onPressed: () => widget.removeFromBlacklist(),
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
