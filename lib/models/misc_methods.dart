import 'package:logging/logging.dart';
import 'package:taxi_chill/models/loader.dart';

logInfo(value) {
  Logger log = Logger('info');
  log.info(value);
}

logError(value) {
  Logger log = Logger('error');
  log.warning('!!!!!!!!!!!!!! $value');
}

clickLoader({required Function setState, required Function run}) {
  setState();
  const Loader();
  run();
}
