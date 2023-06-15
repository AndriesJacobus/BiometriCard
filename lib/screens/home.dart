import 'package:biometricard/models/secure_card.dart';
import 'package:flutter/material.dart';
import 'package:biometricard/components/card_view.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:biometricard/components/new_card.dart';

class MyHomePage extends StatefulWidget {
  String title;

  MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SecureStorage<MyHomePage> {
  bool hasCards = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      hasCards = secureStorage.cachedStoredCards.isNotEmpty;
    });
  }

  Future<void> showAddBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: const NewCard(),
        );
      },
    );

    setState(() {
      hasCards = secureStorage.cachedStoredCards.isNotEmpty;
    });
  }

  Column renderCards() {
    List<CardView> cards = [];

    for (SecureCard card in secureStorage.cachedStoredCards) {
      cards.add(
        CardView(card: card),
      );
    }

    return Column(
      children: [
        ...cards,
      ],
    );
  }

  Column renderNoCards() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: Text(
            'You currently have no saved Cards.\nAdd a Secure Card to get started!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.persianGreen,
            ),
          ),
        ),
        GestureDetector(
          onTap: showAddBottomSheet,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              'Add Secure Card',
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
    );
  }

  void deleteAllCards() async {
    await uiService.showConfirmPopup(
      context,
      "Delete all Cards Permanently?",
      "Are you sure you want to delete all your Secure Cards? This cannot be undone.",
      "Delete Cards",
      popTwice: false,
      callback: () => {secureStorage.removeAllCards()},
    );

    setState(() {
      hasCards = secureStorage.cachedStoredCards.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.persianGreen,
        actions: [
          IconButton(
            onPressed: deleteAllCards,
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: hasCards
            ? const EdgeInsets.only(
                top: 0,
              )
            : null,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                hasCards ? renderCards() : renderNoCards(),
                // const Text("Hi"),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddBottomSheet,
        tooltip: 'Add Card',
        backgroundColor: AppColors.persianGreen,
        child: const Icon(Icons.add_card),
      ),
    );
  }
}
