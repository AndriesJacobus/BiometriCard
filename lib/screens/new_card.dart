import 'package:biometricard/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class NewCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewCardState();
  }
}

class NewCardState extends State<NewCard> {
  String cardNumber = '';
  String expiryDate = '';
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
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.persianBlue.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(128, 199, 97, 0.5),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              CreditCardWidget(
                glassmorphismConfig:
                    useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                bankName: bankName,
                frontCardBorder: !useGlassMorphism
                    ? Border.all(color: Colors.yellowAccent)
                    : null,
                backCardBorder: !useGlassMorphism
                    ? Border.all(color: Colors.yellowAccent)
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
                        expiryDate: expiryDate,
                        themeColor: Colors.blue,
                        textColor: AppColors.persianBlue,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle:
                              const TextStyle(color: AppColors.persianGreen),
                          labelStyle:
                              const TextStyle(color: AppColors.persianGreen),
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle:
                              const TextStyle(color: AppColors.persianGreen),
                          labelStyle:
                              const TextStyle(color: AppColors.persianGreen),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle:
                              const TextStyle(color: AppColors.persianGreen),
                          labelStyle:
                              const TextStyle(color: AppColors.persianGreen),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle:
                              const TextStyle(color: AppColors.persianGreen),
                          labelStyle:
                              const TextStyle(color: AppColors.persianGreen),
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
                            gradient: const LinearGradient(
                              colors: <Color>[
                                AppColors.persianBlue,
                                AppColors.mint,
                                AppColors.lightGreen,
                                AppColors.lightGreen,
                                AppColors.mint,
                                AppColors.persianBlue,
                              ],
                              begin: Alignment(-1, -4),
                              end: Alignment(1, 4),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Validate',
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
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState!.validate()) {
      print('valid!');

      // Get more details using card numbers at
      // https://github.com/binlist/data/blob/master/ranges.csv
    } else {
      print('invalid!');
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
