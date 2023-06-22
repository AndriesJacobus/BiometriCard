import 'package:biometricard/models/country.dart';
import 'package:flutter/material.dart';
import 'package:biometricard/components/new_blacklisted_country.dart';
import 'package:biometricard/services/local_auth_service.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';

class Blacklist extends StatefulWidget {
  const Blacklist({super.key});

  @override
  State<Blacklist> createState() => _BlacklistState();
}

class _BlacklistState extends State<Blacklist>
    with SecureStorage, LocalAuthService {
  bool hasBlacklistedCountries = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      hasBlacklistedCountries =
          secureStorage.cachedBlacklistedCountries.isNotEmpty;
    });
  }

  Column renderBlacklist() {
    List<Widget> countries = [];

    secureStorage.cachedBlacklistedCountries.forEach((key, value) {
      countries.add(
        Text(value.name),
      );
    });

    return Column(
      children: [
        ...countries,
        const Padding(
          padding: EdgeInsets.only(
            bottom: 20,
          ),
        ),
      ],
    );
  }

  Future<void> showBlacklistBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: const NewBlacklistedCountry(),
        );
      },
    );

    setState(() {
      hasBlacklistedCountries =
          secureStorage.cachedBlacklistedCountries.isNotEmpty;
    });
  }

  Column renderEmptyBlacklist() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: Text(
            'You currently have no blacklisted Countries.\nBlacklist a Country to get started!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.persianGreen,
            ),
          ),
        ),
        GestureDetector(
          onTap: showBlacklistBottomSheet,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              'Blacklist Country',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'halter',
                fontSize: 14,
                package: 'flutter_credit_card',
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blacklist"),
        backgroundColor: Colors.black,
      ),
      body: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                (hasBlacklistedCountries)
                    ? renderBlacklist()
                    : renderEmptyBlacklist(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showBlacklistBottomSheet,
        tooltip: 'Blacklist Country',
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
