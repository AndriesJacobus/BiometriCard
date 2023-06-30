import 'package:biometricard/components/icon_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:biometricard/components/live_time_text.dart';
import 'package:uuid/uuid.dart';

class CardView extends StatefulWidget {
  final SecureCard card;
  final Function deleteFunction;

  const CardView({super.key, required this.card, required this.deleteFunction});

  @override
  State<StatefulWidget> createState() {
    return CardViewState();
  }
}

class CardViewState extends State<CardView> with SecureStorage<CardView> {
  Uuid uuid = const Uuid();
  bool isCvvFocused = false;
  bool? isCardUnlocked;

  @override
  void initState() {
    super.initState();
    setState(() {
      isCardUnlocked = true;
    });
  }

  void toggleVisibility() {
    setState(() {
      isCardUnlocked = !isCardUnlocked!;
    });
  }

  String formattedCardNumber(String cardNumber) {
    return cardNumber.replaceAllMapped(
      RegExp(r".{4}"),
      (match) => "${match.group(0)} ",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(10),
      child: Container(
        key: UniqueKey(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.persianGreen),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LiveTimeText(timeString: widget.card.dateAdded!),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconDropdown(
                      cardNumber: widget.card.number,
                      cardCVV: widget.card.cVV,
                    ),
                  ),
                ],
              ),
            ),
            CreditCardWidget(
              key: UniqueKey(),
              glassmorphismConfig: null,
              cardNumber: formattedCardNumber(widget.card.number),
              expiryDate: widget.card.expiryDate,
              cardHolderName: widget.card.holder,
              cvvCode: widget.card.cVV,
              // bankName: widget.card.bankName,
              frontCardBorder: null,
              backCardBorder: null,
              showBackView: isCvvFocused,
              obscureCardNumber: isCardUnlocked!,
              obscureCardCvv: isCardUnlocked!,
              isHolderNameVisible: true,
              cardBgColor: AppColors.cardBgColor,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: toggleVisibility,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: AppColors.mint),
                  child: Row(
                    children: [
                      Text(
                        isCardUnlocked! ? "View" : 'Hide',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          right: 5,
                        ),
                      ),
                      Icon(
                        isCardUnlocked!
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    right: 10,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => widget.deleteFunction(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Row(
                    children: [
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 5,
                        ),
                      ),
                      Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
