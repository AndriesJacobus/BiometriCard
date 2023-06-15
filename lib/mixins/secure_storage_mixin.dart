import 'package:flutter/material.dart';
import 'package:biometricard/services/secure_storage_service.dart';
import 'package:biometricard/services/ui_service.dart';
import 'package:biometricard/services/service_driver.dart';

mixin SecureStorage<T extends StatefulWidget> on State<T> {
  SecureStorageService secureStorage = getIt<SecureStorageService>();
  UiService uiService = getIt<UiService>();
}
