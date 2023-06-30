import 'package:flutter/material.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/models/menu_item.dart';
import 'package:biometricard/components/menu_items.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class IconDropdown extends StatefulWidget {
  final String cardNumber;
  final String cardCVV;

  const IconDropdown({
    Key? key,
    required this.cardNumber,
    required this.cardCVV,
  }) : super(key: key);

  @override
  State<IconDropdown> createState() => _IconDropdownState();
}

class _IconDropdownState extends State<IconDropdown> with SecureStorage {
  Future<void> copyToClipboard(String name, String value) async {
    await uiService.copyValueToClipboard("Card $name", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: const Icon(
              Icons.copy,
              size: 25,
              color: AppColors.mint,
            ),
            items: [
              ...MenuItems.firstItems.map(
                (item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
              ),
            ],
            onChanged: (value) {
              String valueToCopy = value.toString();
              switch (valueToCopy) {
                case "number":
                  copyToClipboard(
                    valueToCopy,
                    widget.cardNumber,
                  );
                  break;
                case "cvv":
                  copyToClipboard(
                    valueToCopy.toUpperCase(),
                    widget.cardCVV,
                  );
                  break;
              }
            },
            dropdownStyleData: DropdownStyleData(
              width: 250,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.persianGreen,
              ),
              elevation: 8,
            ),
          ),
        ),
      ),
    );
  }
}
