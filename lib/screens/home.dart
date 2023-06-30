import 'package:biometricard/screens/blacklist.dart';
import 'package:flutter/material.dart';
import 'package:biometricard/models/auth_status.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:biometricard/services/local_auth_service.dart';
import 'package:biometricard/components/card_view.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:biometricard/components/new_card.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SecureStorage, LocalAuthService {
  bool hasCards = false;
  bool authPassed = false;

  @override
  void initState() {
    super.initState();

    authenticateAndLoadCards();
  }

  Future<void> authenticateAndLoadCards() async {
    AuthStatus authStatus = await authenticateLocally();

    if (authStatus == AuthStatus.success ||
        authStatus == AuthStatus.unsupported) {
      // Load cards
      setState(() {
        authPassed = true;
        hasCards = secureStorage.cachedStoredCards.isNotEmpty;
      });
    } else {
      // Show error message
      showAuthFailureMessage();
    }
  }

  Future<void> showAuthFailureMessage() async {
    await uiService.showConfirmPopup(
      context,
      "Authentication Failed",
      "Authentication has failed. Please try again to view and manage your Secure Cards.",
      "Okay",
      confirmColor: AppColors.persianGreen,
      showCancel: false,
      popTwice: false,
    );

    setState(() {
      authPassed = false;
    });
  }

  Future<void> showAddBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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

    secureStorage.cachedStoredCards.forEach((key, value) {
      cards.add(
        CardView(
          card: value,
          deleteFunction: () => {deleteSpecificCard(key)},
        ),
      );
    });

    return Column(
      children: [
        ...cards,
        const Padding(
          padding: EdgeInsets.only(
            bottom: 20,
          ),
        ),
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

  void deleteSpecificCard(String cardKey) async {
    await uiService.showConfirmPopup(
      context,
      "Delete this Card Permanently?",
      "Are you sure you want to delete your Secure Card? This cannot be undone.",
      "Delete Card",
      popTwice: false,
      callback: () => {secureStorage.removeCard(cardKey)},
    );

    setState(() {
      hasCards = secureStorage.cachedStoredCards.isNotEmpty;
    });
  }

  Widget renderAuthPassed() {
    if (hasCards) {
      return renderCards();
    } else {
      return renderNoCards();
    }
  }

  Column renderAuthNotPassed() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: Text(
            'Authenticate your profile to view and manage your Secure Cards.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.persianGreen,
            ),
          ),
        ),
        GestureDetector(
          onTap: authenticateAndLoadCards,
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
              'Authenticate',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.persianGreen,
        leading: (authPassed)
            ? IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Blacklist(),
                    ),
                  ),
                },
                icon: const Icon(Icons.view_list_rounded),
              )
            : null,
        actions: [
          if (authPassed)
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
                authPassed ? renderAuthPassed() : renderAuthNotPassed(),
                // const Text("Hi"),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: authPassed
          ? FloatingActionButton(
              onPressed: showAddBottomSheet,
              tooltip: 'Add Card',
              backgroundColor: AppColors.persianGreen,
              child: const Icon(Icons.add_card),
            )
          : null,
    );
  }
}
