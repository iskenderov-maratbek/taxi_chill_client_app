import 'package:logger/logger.dart';
import 'package:taxi_chill/models/loader.dart';

logInfo(value) {
  Logger log = Logger();
  log.i('===!!!======Информация: $value');
}

logError(value) {
  Logger log = Logger();
  log.e('=========Ошибка: $value');
}

logBuild(Type type) {
  Logger log = Logger();
  log.i('=========Постройка: $type');
}

clickLoader({required Function setState, required Function run}) {
  setState();
  const Loader();
  run();
}
