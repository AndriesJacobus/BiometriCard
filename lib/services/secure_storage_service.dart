import 'package:flutter/material.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class SecureStorageService {
  // Save local cards in state (memory) from secure storage
  // Sync up between secure storage and local state
  FlutterSecureStorage? storage;
  Map<String, SecureCard> cachedStoredCards = <String, SecureCard>{};
  Uuid uuid = const Uuid();

  Future init() async {
    debugPrint("Here in SecureStorageService init...");

    // Create storage
    storage = const FlutterSecureStorage();

    // Load stored cards form secure storage into cache
    await _loadStoredCards();
  }

  Future<void> _loadStoredCards() async {
    Map<String, String>? allStoredItems = await storage?.readAll();

    // Go through allStoredCards and deserialise into list of SecureCards
    allStoredItems?.forEach((key, value) {
      // Make sure this is a stored card
      if (key.substring(0, 5) == "scard") {
        debugPrint("Adding a card to memory...");
        cachedStoredCards.addAll({key: SecureCard.deserialize(value)});
      }
    });
  }

  Future<bool> saveAndStoreCard(SecureCard card) async {
    // First make sure the card doesn't exist already
    if (cardExists(card)) {
      debugPrint("Card already exists");
      return false;
    }

    // Store card in secure storage
    // String newKey = "scard${uuid.v4().replaceAll("-", "")}";
    String newKey = "scard_${card.dateAdded}";
    await storage?.write(
      key: newKey,
      value: SecureCard.serialize(card),
    );

    // Add the card to memory
    cachedStoredCards.addAll({newKey: card});

    return true;
  }

  Future<void> removeAllCards() async {
    // Remove from memory
    cachedStoredCards.clear();

    // Remove from storage
    await storage?.deleteAll();
  }

  Future<void> removeCard(String cardKey) async {
    // Remove from memory
    cachedStoredCards.remove(cardKey);

    // Remove from storage
    await storage?.delete(key: cardKey);
  }

  bool cardExists(SecureCard card) {
    // Check if a card with the same number already exists
    return cachedStoredCards.values.toList().any(
          (existingCard) => existingCard.number == card.number,
        );
  }
}
