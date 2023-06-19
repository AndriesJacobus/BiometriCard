import 'dart:convert';

class SecureCard {
  String number;
  String expiryDate;
  String cVV;
  String holder;
  String type;
  String? country;
  String? dateAdded;

  SecureCard({
    required this.number,
    required this.expiryDate,
    required this.cVV,
    required this.holder,
    required this.type,
    this.country,
    this.dateAdded,
  });

  factory SecureCard.fromJson(Map<String, dynamic> jsonData) {
    return SecureCard(
      number: jsonData['number'] ?? "N/A",
      expiryDate: jsonData['expiryDate'] ?? "N/A",
      cVV: jsonData['cVV'] ?? "N/A",
      holder: jsonData['holder'] ?? "N/A",
      type: jsonData['type'] ?? "N/A",
      country: jsonData['country'] ?? "N/A",
      dateAdded: jsonData['dateAdded'] ?? "N/A",
    );
  }

  static Map<String, dynamic> toMap(SecureCard model) => <String, dynamic>{
        'number': model.number,
        'expiryDate': model.expiryDate,
        'cVV': model.cVV,
        'holder': model.holder,
        'type': model.type,
        'country': model.country ?? "N/A",
        'dateAdded': model.dateAdded ?? "N/A",
      };

  static String serialize(SecureCard card) =>
      json.encode(SecureCard.toMap(card));

  static SecureCard deserialize(String json) =>
      SecureCard.fromJson(jsonDecode(json));
}

// Usage:
// final FlutterSecureStorage storage = FlutterSecureStorage();

// await storage.write(key: key, value: MyUserModel.serialize(model));

// MyUserModel model = MyUserModel.deserialize(await storage.read(key: key));