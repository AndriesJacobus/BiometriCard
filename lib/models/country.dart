import 'dart:convert';

class Country {
  final String name;
  final String code;

  const Country({
    required this.name,
    required this.code,
  });

  factory Country.fromJson(Map<String, dynamic> jsonData) {
    return Country(
      name: jsonData['name'] ?? "N/A",
      code: jsonData['code'] ?? "N/A",
    );
  }

  static Map<String, dynamic> toMap(Country model) => <String, dynamic>{
        'name': model.name,
        'code': model.code,
      };

  static String serialize(Country card) => json.encode(Country.toMap(card));

  static Country deserialize(String json) => Country.fromJson(jsonDecode(json));
}
