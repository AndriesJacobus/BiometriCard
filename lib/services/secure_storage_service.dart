import 'package:flutter/material.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class SecureStorageService {
  // Save local cards in state (memory) from secure storage
  // Sync up between secure storage and local state
  FlutterSecureStorage? storage;
  List<SecureCard> cachedStoredCards = [];
  Uuid uuid = const Uuid();

  Future init() async {
    debugPrint("Here in SecureStorageService init...");

    // Create storage
    storage = const FlutterSecureStorage();

    // Load stored cards form secure storage into cache
    _loadStoredCards();
  }

  Future<void> _loadStoredCards() async {
    Map<String, String>? allStoredCards = await storage?.readAll();

    // Go through allStoredCards and deserialise into list of SecureCards
    allStoredCards?.forEach((key, value) {
      // Make sure this is a stored card
      if (key.substring(0, 5) == "scard") {
        debugPrint("Adding a card to memory...");
        cachedStoredCards.add(SecureCard.deserialize(value));
      }
    });
  }

  Future<bool> saveAndStoreCard(SecureCard card) async {
    // First make sure the card doesn't exist already
    if (cardExists(card)) {
      debugPrint("Card already exists");
      return false;
    }

    // Add a card to memory
    cachedStoredCards.add(card);

    // Store card in secure storage
    await storage?.write(
      key: "scard${uuid.v4().replaceAll("-", "")}",
      value: SecureCard.serialize(card),
    );
    return true;
  }

  Future<void> removeAllCards(SecureCard card) async {
    await storage?.deleteAll();
  }

  bool cardExists(SecureCard card) {
    return cachedStoredCards.any(
      (existingCard) => existingCard.number == card.number,
    );
  }
}
