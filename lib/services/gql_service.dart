gqlrequest(String schema) async {
  logInfo('Создание запроса');
  final QueryResult result = await client.value.query(QueryOptions(
    document: gql(schema),
  ));

  if (result.hasException) {
    logError('Ошибка выполнения запроса: ${result.exception.toString()}');
  } else {
    // Обработка успешного выполнения запроса
    logInfo(result.data);
  }
}
