import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:biometricard/models/i_n_n_entry.dart';

class CardCountries {
  // Load countries from csv
  final Map<String, INNEntry> _iNNData = <String, INNEntry>{};

  Future init() async {
    final rawData =
        await rootBundle.loadString("assets/static_data/cardCountries.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(
      rawData,
    );

    // iNNData = listData.sublist(1, listData.length);
    // iNNData:
    // Ignore first row, since its the titles

    listData.sublist(1, listData.length).forEach(
      (tuple) {
        // iin_start, country, bank_name, bank_url, bank_city
        _iNNData.addAll({
          "${tuple[0]}": INNEntry(
            inn: "${tuple[0]}",
            country: "${tuple[1]}",
            bankName: "${tuple[2]}",
            bankUrl: "${tuple[3]}",
            bankCity: "${tuple[4]}",
          ),
        });
      },
    );

    debugPrint("Country data loaded ${_iNNData.length} entries.");
  }

  bool iNNExists(String iNN) {
    // Check if a card with the same number already exists
    return _iNNData[iNN] != null;
  }

  INNEntry? getCardDataForInn(String iNN) {
    return _iNNData[iNN];
  }
}
