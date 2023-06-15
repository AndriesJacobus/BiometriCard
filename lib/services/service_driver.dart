import 'package:biometricard/services/secure_storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.I;

setupServices() async {
  getIt.registerSingleton<SecureStorageService>(SecureStorageService());

  await getIt<SecureStorageService>().init();
}
