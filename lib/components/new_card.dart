import 'package:flutter/material.dart';
import 'package:biometricard/models/country.dart';
import 'package:biometricard/models/i_n_n_entry.dart';
import 'package:flutter/foundation.dart';
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
  String cardType = '';

  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isSim = false;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  @override
  void initState() {
    super.initState();

    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.persianBlue.withOpacity(0.7),
        width: 2.0,
      ),
    );

    _cardNumberController.text = cardNumber;
    _expiryDateController.text = capturedExpiryDate;
    _cardHolderNameController.text = cardHolderName;
    _cvvCodeController.text = cvvCode;

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

  void onCreditCardDetailChange(SecureCard creditCardModel, bool cvvFocused) {
    setState(() {
      cardNumber = creditCardModel.number;
      capturedExpiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.holder;
      cvvCode = creditCardModel.cVV;
      isCvvFocused = cvvFocused;
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

      debugPrint("Card details: ${cardDetails.toString()}");

      _cardNumberController.text = cardDetails!.cardNumber;
      _expiryDateController.text = cardDetails.expiryDate;
      _cardHolderNameController.text = cardDetails.cardHolderName;

      // Add card details and remove
      setState(() {
        cardNumber = cardDetails.cardNumber;
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
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card number',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              controller: _cardNumberController,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 16) {
                  return 'Please enter card number';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  cardNumber = value;
                });
              },
              onTap: () {
                setState(() {
                  isCvvFocused = false;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Expired Date',
                      hintText: 'MM/YY',
                    ),
                    controller: _expiryDateController,
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      final DateTime now = DateTime.now();
                      final List<String> date = value.split(RegExp(r'/'));
                      final int month = int.parse(date.first);
                      final int year = int.parse('20${date.last}');
                      final int lastDayOfMonth = month < 12
                          ? DateTime(year, month + 1, 0).day
                          : DateTime(year + 1, 1, 0).day;
                      final DateTime cardDate = DateTime(
                        year,
                        month,
                        lastDayOfMonth,
                        23,
                        59,
                        59,
                        999,
                      );

                      if (cardDate.isBefore(now) || month > 12 || month == 0) {
                        return 'Please input a valid date';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      String expiry = value;
                      if (expiry.startsWith(RegExp('[2-9]'))) {
                        expiry = '0$expiry';
                      }
                      setState(() {
                        capturedExpiryDate = expiry;
                      });
                    },
                    onTap: () {
                      setState(() {
                        isCvvFocused = false;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    controller: _cvvCodeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter CVV';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        cvvCode = value;
                      });
                    },
                    onTap: () {
                      setState(() {
                        isCvvFocused = true;
                      });
                    },
                    onTapOutside: (event) {
                      setState(() {
                        isCvvFocused = false;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card Holder Name',
              ),
              controller: _cardHolderNameController,
              onChanged: (value) {
                setState(() {
                  cardHolderName = value;
                });
              },
              onTap: () {
                setState(() {
                  isCvvFocused = false;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onValidate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Save'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: scanCardDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mint,
                ),
                child: const Text('Scan Card'),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
              ),
              ElevatedButton(
                onPressed: () async => uiService.showConfirmPopup(
                  context,
                  "Are you sure?",
                  "Are you sure you want to discard this new Secure Card?",
                  "Discard",
                  popTwice: true,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Discard'),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 40,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
