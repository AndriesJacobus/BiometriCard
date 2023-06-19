import 'package:flutter/material.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;

class CardView extends StatefulWidget {
  SecureCard card;
  CardView({super.key, required this.card});

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

  @override
  Widget build(BuildContext context) {
    DateTime cardCreatedAt = DateTime.parse(widget.card.dateAdded!);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.persianGreen),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
              ),
              child: Text(
                'Added ${timeago.format(cardCreatedAt).toString()}',
                style: const TextStyle(
                  color: AppColors.persianGreen,
                  fontSize: 14,
                ),
              ),
            ),
            CreditCardWidget(
              glassmorphismConfig: null,
              cardNumber: widget.card.number,
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
                        isCardUnlocked! ? "Unlock" : 'Lock',
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
                            ? Icons.lock_open_rounded
                            : Icons.lock_rounded,
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
                  onPressed: () async => {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Row(
                    children: const [
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
