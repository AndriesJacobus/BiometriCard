import 'package:flutter/material.dart';
import 'package:biometricard/models/country.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';

class NewBlacklistedCountry extends StatefulWidget {
  const NewBlacklistedCountry({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewBlacklistedCountryState();
  }
}

class NewBlacklistedCountryState extends State<NewBlacklistedCountry>
    with SecureStorage {
  Country? toBlacklist;

  @override
  void initState() {
    super.initState();

    setState(() {
      toBlacklist = const Country(name: "Afghanistan", code: "AF");
    });
  }

  void showSuccessPopup() {
    // Show popup
    uiService.showConfirmPopup(
      context,
      "Country Blacklisted successfully",
      "${toBlacklist!.name} has been successfully blacklisted",
      "View Blacklist",
      showCancel: false,
      popTwice: true,
      confirmColor: AppColors.persianGreen,
    );
  }

  void showFailurePopup() {
    // Show popup
    uiService.showConfirmPopup(
      context,
      "Country already Blacklisted",
      "There was an error blacklisting ${toBlacklist!.name}: Already Blacklisted.\n\nPlease choose another Country to Blacklist.",
      "Try again",
      showCancel: false,
      popTwice: false,
      confirmColor: Colors.black,
    );
  }

  void showNoCountryPopup() {
    // Show popup
    uiService.showConfirmPopup(
      context,
      "No Country Selected",
      "There was an error blacklisting a Country: No Country Selected.\n\nPlease choose a Country to Blacklist.",
      "Try again",
      showCancel: false,
      popTwice: false,
      confirmColor: Colors.black,
    );
  }

  void _blacklistCountry() async {
    if (toBlacklist != null) {
      bool saveSuccess = await secureStorage.blacklistCountry(toBlacklist!);

      if (saveSuccess) {
        // Show success popup
        showSuccessPopup();
      } else {
        showFailurePopup();
      }
    } else {
      // Show error popup
      showNoCountryPopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Blacklist a Country",
                style: TextStyle(
                  color: AppColors.persianBlue,
                  fontFamily: 'halter',
                  fontSize: 16,
                  package: 'flutter_credit_card',
                ),
              ),
            ),
            CountryListPick(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const Text('Choose Country to Blacklist'),
              ),
              theme: CountryTheme(
                isShowFlag: true,
                isShowTitle: true,
                isShowCode: false,
                isDownIcon: true,
                showEnglishName: true,
              ),
              onChanged: (CountryCode? countryCode) {
                debugPrint("Selected Country:");
                debugPrint(countryCode?.name);
                debugPrint(countryCode?.code);
                if (countryCode != null &&
                    countryCode.name != null &&
                    countryCode.code != null) {
                  setState(() {
                    toBlacklist = Country(
                      name: countryCode.name ?? "",
                      code: countryCode.code ?? "",
                    );
                  });
                }
              },
              useUiOverlay: true,
              useSafeArea: false,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: GestureDetector(
                onTap: _blacklistCountry,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'Blacklist',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'halter',
                      fontSize: 14,
                      package: 'flutter_credit_card',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
