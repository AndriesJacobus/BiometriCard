import 'package:biometricard/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

import '../services/service_driver.dart';

mixin SecureStorage<T extends StatefulWidget> on State<T> {
  var api = getIt<SecureStorageService>();
}
