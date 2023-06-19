import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:biometricard/models/auth_status.dart';

class LocalAuthService {
  LocalAuthentication auth = LocalAuthentication();

  Future<AuthStatus> canAuthenticate() async {
    bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    bool authenticateSupported =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    debugPrint("authenticateSupported: $authenticateSupported");
    return authenticateSupported ? AuthStatus.success : AuthStatus.unsupported;
  }

  Future<AuthStatus> authenticateLocally() async {
    if (await canAuthenticate() == AuthStatus.success) {
      try {
        final bool didAuthenticate = await auth!.authenticate(
          localizedReason: 'Please authenticate to manage your Secure Cards',
        );

        debugPrint("didAuthenticate: $didAuthenticate");
        return didAuthenticate ? AuthStatus.success : AuthStatus.fail;
      } on PlatformException catch (e) {
        debugPrint("Error authenticating:");
        debugPrint(e.toString());
        return AuthStatus.fail;
      }
    } else {
      debugPrint("Auth is unsupported");
      return AuthStatus.unsupported;
    }
  }
}
