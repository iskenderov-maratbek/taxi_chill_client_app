import 'package:taxi_chill/views/misc/loader.dart';

logInfo(value) {
  print(value);
}

logBuild(value) {
  print('BUILD: $value');
}

logDispose(value) {
  print('DISPOSE: $value');
}

logRequest(value) {
  print('REQUEST: $value');
}

logError(value) {
  print('ERROR: $value');
}

clickLoader({required Function setState, required Function run}) {
  setState();
  const Loader();
  run();
}

Uri getRoute(route) => Uri.parse('http://192.168.8.100:3000+$route');
