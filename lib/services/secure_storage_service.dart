import 'package:flutter/material.dart';
import 'package:biometricard/models/country.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class SecureStorageService {
  // Save local cards in state (memory) from secure storage
  // Sync up between secure storage and local state
  FlutterSecureStorage? storage;
  Map<String, SecureCard> cachedStoredCards = <String, SecureCard>{};
  Map<String, Country> cachedBlacklistedCountries = <String, Country>{};
  Uuid uuid = const Uuid();

  Future init() async {
    // Create storage
    storage = const FlutterSecureStorage();

    // Load stored cards form secure storage into cache
    await _loadStoredEntities();
  }

  Future<void> _loadStoredEntities() async {
    Map<String, String>? allStoredItems = await storage?.readAll();

    // Go through allStoredCards and deserialise into list of SecureCards
    allStoredItems?.forEach((key, value) {
      // Make sure this is a stored card
      if (key.substring(0, 5) == "scard") {
        // debugPrint("Adding a card to memory...");
        cachedStoredCards.addAll({key: SecureCard.deserialize(value)});
      } else if (key.substring(0, 8) == "bcountry") {
        // debugPrint("Adding a blacklisted country to memory...");
        cachedBlacklistedCountries.addAll({key: Country.deserialize(value)});
      }
    });

    debugPrint("Stored entries loaded.");
  }

  Future<bool> saveAndStoreCard(SecureCard card) async {
    // First make sure the card doesn't exist already
    if (cardExists(card)) {
      debugPrint("Card already exists");
      return false;
    }

    // Store card in secure storage
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

  // Methods for blacklisted countries

  Future<bool> blacklistCountry(Country country) async {
    // First make sure the card doesn't exist already
    if (countryBlacklisted(country)) {
      debugPrint("Country already blacklisted");
      return false;
    }

    // Store card in secure storage
    String newKey = "bcountry_${DateTime.now().toString().split(".")[0]}";
    await storage?.write(
      key: newKey,
      value: Country.serialize(country),
    );

    // Add the card to memory
    cachedBlacklistedCountries.addAll({newKey: country});

    return true;
  }

  bool countryBlacklisted(Country country) {
    // Check if a country with the same code already blacklisted
    return cachedBlacklistedCountries.values.toList().any(
          (existingCountry) => existingCountry.code == country.code,
        );
  }

  Future<void> removeAllCountres() async {
    // Remove from memory
    cachedBlacklistedCountries.clear();

    // Remove from storage
    await storage?.deleteAll();
  }

  Future<void> removeCountry(String countryKey) async {
    // Remove from memory
    cachedBlacklistedCountries.remove(countryKey);

    // Remove from storage
    await storage?.delete(key: countryKey);
  }
}
