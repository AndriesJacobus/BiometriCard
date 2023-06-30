class INNEntry {
  // iin_start, country, bank_name, bank_url, bank_city
  final String inn;
  final String country;
  final String? bankName;
  final String? bankUrl;
  final String? bankCity;

  const INNEntry({
    required this.inn,
    required this.country,
    this.bankName,
    this.bankUrl,
    this.bankCity,
  });

  @override
  String toString() {
    return country;
  }
}
