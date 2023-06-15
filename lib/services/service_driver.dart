import 'package:get_it/get_it.dart';
import 'package:biometricard/services/ui_service.dart';
import 'package:biometricard/services/secure_storage_service.dart';

final getIt = GetIt.I;

setupServices() async {
  getIt.registerSingleton<SecureStorageService>(SecureStorageService());
  getIt.registerSingleton<UiService>(UiService());

  await getIt<SecureStorageService>().init();
}
