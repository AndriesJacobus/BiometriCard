import 'package:flutter/material.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:biometricard/models/secure_card.dart';

class CardView extends StatefulWidget {
  SecureCard card;
  CardView({super.key, required this.card});

  @override
  State<StatefulWidget> createState() {
    return CardViewState();
  }
}

class CardViewState extends State<CardView> with SecureStorage<CardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("We have a card!");
  }
}
