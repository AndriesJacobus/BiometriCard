import 'package:flutter/material.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';

class BiometricardCreditCardForm extends StatefulWidget {
  final SecureCard card;
  final Function updateCardDetailCallback;

  const BiometricardCreditCardForm({
    Key? key,
    required this.card,
    required this.updateCardDetailCallback,
  }) : super(key: key);

  @override
  State<BiometricardCreditCardForm> createState() =>
      _BiometricardCreditCardFormState();
}

class _BiometricardCreditCardFormState extends State<BiometricardCreditCardForm>
    with SecureStorage {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text("Eh"),
    );
  }
}
