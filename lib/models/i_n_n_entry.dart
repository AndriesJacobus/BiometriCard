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
    String ret = "INN Number: $inn\nCountry: $country";
    if (bankName != null) {
      ret += "\nBank: $bankName";
    }
    if (bankUrl != null) {
      ret += "\nBank Url: $bankUrl";
    }
    if (bankUrl != null) {
      ret += "\nBank City: $bankCity";
    }

    return ret;
  }
}
