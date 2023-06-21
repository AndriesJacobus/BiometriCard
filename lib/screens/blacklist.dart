import 'package:flutter/material.dart';
import 'package:biometricard/models/auth_status.dart';
import 'package:biometricard/models/secure_card.dart';
import 'package:biometricard/services/local_auth_service.dart';
import 'package:biometricard/components/card_view.dart';
import 'package:biometricard/common/colors.dart';
import 'package:biometricard/mixins/secure_storage_mixin.dart';
import 'package:biometricard/components/new_card.dart';

class Blacklist extends StatefulWidget {
  const Blacklist({super.key});

  @override
  State<Blacklist> createState() => _BlacklistState();
}

class _BlacklistState extends State<Blacklist>
    with SecureStorage, LocalAuthService {
  bool hasCards = false;
  bool authPassed = false;

  @override
  void initState() {
    super.initState();
  }

  Column renderBlacklist() {
    return Column(
      children: [
        const Text("Oh oh"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blacklist"),
        backgroundColor: AppColors.persianGreen,
      ),
      body: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[renderBlacklist()],
            ),
          ),
        ),
      ),
      floatingActionButton: authPassed
          ? FloatingActionButton(
              onPressed: () => {},
              tooltip: 'Add Country',
              backgroundColor: AppColors.persianGreen,
              child: const Icon(Icons.add_circle),
            )
          : null,
    );
  }
}
