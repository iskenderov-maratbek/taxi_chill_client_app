import 'package:logger/logger.dart';
import 'package:taxi_chill/models/loader.dart';

logInfo(value) {
  Logger log = Logger();
  log.i(value);
}

logError(value) {
  Logger log = Logger();
  log.e(value);
}

clickLoader({required Function setState, required Function run}) {
  setState();
  const Loader();
  run();
}
