import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:taxi_chill/main.dart';
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
