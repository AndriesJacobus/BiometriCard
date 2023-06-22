import 'package:biometricard/components/blacklisted_country.dart';
import 'package:biometricard/models/country.dart';
import 'package:biometricard/models/iNNEntry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';

class NewCard extends StatefulWidget {
  const NewCard({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewCardState();
  }
}

class NewCardState extends State<NewCard> with SecureStorage<NewCard> {
  String cardNumber = '';
  String capturedExpiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String bankName = ' ';

  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isSim = false;

  @override
  void initState() {
    super.initState();

    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.persianBlue.withOpacity(0.7),
        width: 2.0,
      ),
    );

    detectSims();
  }

  Future<void> detectSims() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;

      setState(() {
        isSim = !androidInfo.isPhysicalDevice;
      });
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;

      setState(() {
        isSim = !iosInfo.isPhysicalDevice;
      });
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      capturedExpiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void showSuccessPopup() {
    // Show popup
    uiService.showConfirmPopup(
      context,
      "Secure Card saved successfully",
      "Your new Secure Card has been successfully saved, and stored securely!",
      "View Secure Cards",
      showCancel: false,
      popTwice: true,
      confirmColor: AppColors.persianGreen,
    );
  }

  void showCardFailurePopup() {
    // Show popup
    uiService.showConfirmPopup(
      context,
      "Secure Card already exists",
      "There was an error saving your new card: Secure Card already exists.\n\nPlease review your details and try again.",
      "Try again",
      popTwice: false,
      confirmColor: Colors.black,
    );
  }

  void showCardBlacklistedPopup() async {
    await uiService.showConfirmPopup(
      context,
      "Card Country is Blacklisted",
      "There was an error saving your new card: Card Country is Blacklisted.\n\nPlease enter card details of a card not blacklisted.",
      "Try again",
      showCancel: false,
      popTwice: false,
      confirmColor: Colors.black,
    );
  }

  void _onValidate() async {
    if (formKey.currentState!.validate()) {
      debugPrint('Card valid!');

      // Check card to make sure it isn't blacklisted
      // Get INNEntry using INN number (first 6 digits of card number)
      INNEntry? innEntry = cardCountries
          .getCardDataForInn(cardNumber.replaceAll(" ", "").substring(0, 6));

      if (innEntry != null) {
        // debugPrint("innEntry code: ${innEntry.toString()}");
        // Make sure blacklist doesn't include country with innEntry's code
        bool blacklisted = secureStorage.countryBlacklisted(
          Country(
            name: "",
            code: innEntry.country,
          ),
        );

        if (blacklisted) {
          showCardBlacklistedPopup();
          return;
        }
      }

      // Save card to secure storage
      bool saveSuccess = await secureStorage.saveAndStoreCard(
        SecureCard(
          number: cardNumber,
          expiryDate: capturedExpiryDate,
          cVV: cvvCode,
          holder: cardHolderName,
          type: "",
          dateAdded: DateTime.now().toString().split(".")[0],
        ),
      );

      if (saveSuccess) {
        showSuccessPopup();
      } else {
        showCardFailurePopup();
      }
    } else {
      debugPrint('Card invalid!');
    }
  }

  Future<void> scanCardDetails() async {
    // Add card details and remove
    if (!isSim) {
      var cardDetails = await CardScanner.scanCard(
        scanOptions: const CardScanOptions(
          scanCardHolderName: true,
          scanExpiryDate: true,
          considerPastDatesInExpiryDateScan: true,
        ),
      );

      // debugPrint(cardDetails.toString());

      // Add card details and remove
      setState(() {
        cardNumber = cardDetails!.cardNumber;
        capturedExpiryDate = cardDetails.expiryDate;
        cardHolderName = cardDetails.cardHolderName;
      });

      // Post toast
      uiService.doToast("Card scanned successfully");
    } else {
      uiService.showConfirmPopup(
        context,
        "Option not supported on Simulator",
        "To use the Scan Card feature, please connect flutter to a physical device.",
        "Okay",
        showCancel: false,
        popTwice: false,
      );
    }
  }

  Widget renderCardForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CreditCardForm(
            key: UniqueKey(),
            formKey: formKey,
            obscureCvv: true,
            obscureNumber: true,
            cardNumber: cardNumber,
            cvvCode: cvvCode,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            cardHolderName: cardHolderName,
            expiryDate: capturedExpiryDate,
            themeColor: Colors.blue,
            textColor: AppColors.persianBlue,
            cardNumberDecoration: InputDecoration(
              labelText: 'Number',
              hintText: 'XXXX XXXX XXXX XXXX',
              hintStyle: const TextStyle(color: AppColors.persianGreen),
              labelStyle: const TextStyle(color: AppColors.persianBlue),
              focusedBorder: border,
              enabledBorder: border,
            ),
            expiryDateDecoration: InputDecoration(
              hintStyle: const TextStyle(color: AppColors.persianGreen),
              labelStyle: const TextStyle(color: AppColors.persianBlue),
              focusedBorder: border,
              enabledBorder: border,
              labelText: 'Expired Date',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: InputDecoration(
              hintStyle: const TextStyle(color: AppColors.persianGreen),
              labelStyle: const TextStyle(color: AppColors.persianBlue),
              focusedBorder: border,
              enabledBorder: border,
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: InputDecoration(
              hintStyle: const TextStyle(color: AppColors.persianGreen),
              labelStyle: const TextStyle(color: AppColors.persianBlue),
              focusedBorder: border,
              enabledBorder: border,
              labelText: 'Card Holder',
            ),
            onCreditCardModelChange: onCreditCardModelChange,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: scanCardDetails,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 120),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Scan Card',
                style: TextStyle(
                  color: AppColors.persianBlue,
                  fontFamily: 'halter',
                  fontSize: 14,
                  package: 'flutter_credit_card',
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onValidate,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.persianBlue,
                  fontFamily: 'halter',
                  fontSize: 14,
                  package: 'flutter_credit_card',
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async => uiService.showConfirmPopup(
              context,
              "Are you sure?",
              "Are you sure you want to discard this new Secure Card?",
              "Discard",
              popTwice: true,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Discard',
                style: TextStyle(
                  color: AppColors.persianBlue,
                  fontFamily: 'halter',
                  fontSize: 14,
                  package: 'flutter_credit_card',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Add a new Secure Card",
              style: TextStyle(
                color: AppColors.persianBlue,
                fontFamily: 'halter',
                fontSize: 16,
                package: 'flutter_credit_card',
              ),
            ),
            CreditCardWidget(
              glassmorphismConfig:
                  useGlassMorphism ? Glassmorphism.defaultConfig() : null,
              cardNumber: cardNumber,
              expiryDate: capturedExpiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              bankName: bankName,
              frontCardBorder: !useGlassMorphism
                  ? Border.all(color: AppColors.lightGreen)
                  : null,
              backCardBorder: !useGlassMorphism
                  ? Border.all(color: AppColors.lightGreen)
                  : null,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: AppColors.cardBgColor,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: renderCardForm(),
            ),
          ],
        ),
      ),
    );
  }
}
