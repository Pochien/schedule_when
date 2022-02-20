import 'package:get_it/get_it.dart';
import 'package:schedule_when/services/navigation_service.dart';

GetIt locator = GetIt.instance;

void registerLocator() {
  GetIt.I.registerSingleton(() => NavigationService());
}

void setupLocator() {
  GetIt.I.registerLazySingleton(() => NavigationService());
}
