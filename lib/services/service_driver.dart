import 'package:get_it/get_it.dart';
import 'package:biometricard/services/card_countries.dart';
import 'package:biometricard/services/local_auth_service.dart';
import 'package:biometricard/services/ui_service.dart';
import 'package:biometricard/services/secure_storage_service.dart';

final getIt = GetIt.I;

setupServices() async {
  getIt.registerSingleton<LocalAuthService>(LocalAuthService());
  getIt.registerSingleton<SecureStorageService>(SecureStorageService());
  getIt.registerSingleton<UiService>(UiService());
  getIt.registerSingleton<CardCountries>(CardCountries());

  await getIt<SecureStorageService>().init();
  await getIt<CardCountries>().init();
}
