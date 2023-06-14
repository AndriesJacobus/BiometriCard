import 'dart:convert';

class SecureCard {
  String number;
  String date;
  String cVV;
  String holder;
  String type;
  String? country;

  SecureCard({
    required this.number,
    required this.date,
    required this.cVV,
    required this.holder,
    required this.type,
    this.country,
  });

  factory SecureCard.fromJson(Map<String, dynamic> jsonData) {
    return SecureCard(
      number: jsonData['number'] ?? "N/A",
      date: jsonData['date'] ?? "N/A",
      cVV: jsonData['cVV'] ?? "N/A",
      holder: jsonData['holder'] ?? "N/A",
      type: jsonData['type'] ?? "N/A",
      country: jsonData['country'] ?? "N/A",
    );
  }

  static Map<String, dynamic> toMap(SecureCard model) => <String, dynamic>{
        'number': model.number,
        'date': model.date,
        'cVV': model.cVV,
        'holder': model.holder,
        'type': model.type,
        'country': model.country ?? "N/A",
      };

  static String serialize(SecureCard model) =>
      json.encode(SecureCard.toMap(model));

  static SecureCard deserialize(String json) =>
      SecureCard.fromJson(jsonDecode(json));
}
