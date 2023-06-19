import 'package:flutter/material.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

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

  @override
  void initState() {
    super.initState();
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.persianBlue.withOpacity(0.7),
        width: 2.0,
      ),
    );
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
      "Secure Card saved Successfully",
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
      "Secure Card already Exists",
      "There was an error saving your new card: Secure Card already exists.\n\nPlease review your details and try again.",
      "Try again",
      popTwice: false,
      confirmColor: Colors.black,
    );
  }

  void _onValidate() async {
    if (formKey.currentState!.validate()) {
      debugPrint('Card valid!');

      // Get more details using card numbers at
      // https://github.com/binlist/data/blob/master/ranges.csv

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
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
                        hintStyle:
                            const TextStyle(color: AppColors.persianGreen),
                        labelStyle:
                            const TextStyle(color: AppColors.persianBlue),
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: AppColors.persianGreen),
                        labelStyle:
                            const TextStyle(color: AppColors.persianBlue),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: AppColors.persianGreen),
                        labelStyle:
                            const TextStyle(color: AppColors.persianBlue),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: AppColors.persianGreen),
                        labelStyle:
                            const TextStyle(color: AppColors.persianBlue),
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
                      onTap: _onValidate,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
