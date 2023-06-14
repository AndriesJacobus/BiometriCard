import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin SecureStorageService<T extends StatefulWidget> on State<T> {
  // Save local cards in state from secure storage
  // Sync up between secure storage and local state
  FlutterSecureStorage? storage;
  Map<String, String>? cachedStoredCards;

  @override
  void initState() {
    super.initState();

    // Create storage
    storage = const FlutterSecureStorage();

    // Load stored cards form secure storage into cache
    loadStoredCards();
  }

  Future<void> loadStoredCards() async {
    Map<String, String>? allStoredCards = await storage?.readAll();

    setState(() {
      cachedStoredCards = allStoredCards;
    });

    // // Read value
    // String value = await storage.read(key: key);

    // // Read all values
    // Map<String, String> allValues = await storage.readAll();

    // // Delete value
    // await storage.delete(key: key);

    // // Delete all
    // await storage.deleteAll();

    // // Write value
    // await storage.write(key: key, value: value);
  }

  Future<void> saveAndStoreCard() async {
    // Puts card in memory
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

// Usage:
// final FlutterSecureStorage storage = FlutterSecureStorage();

// await storage.write(key: key, value: MyUserModel.serialize(model));

// MyUserModel model = MyUserModel.deserialize(await storage.read(key: key));