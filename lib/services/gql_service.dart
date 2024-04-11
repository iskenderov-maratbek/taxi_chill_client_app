import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taxi_chill/models/misc_methods.dart';

import '../main.dart';

Map<String, String> dataRequests = {
  'auth': '''
            query {
                  hello
                  }
          ''',
};

gqlRequest(String schema) async {
  logInfo('Создание запроса');
  final QueryResult result = await client.value.query(QueryOptions(
    document: gql(dataRequests[schema]!),
  ));

  if (result.hasException) {
    logError('Ошибка выполнения запроса: ${result.exception.toString()}');
  } else {
    // Обработка успешного выполнения запроса
    logInfo(result.data);
  }
}

gqlMutate(String email) async {
  logInfo(email);
  client.value.mutate(
    MutationOptions(
      document: gql("""
mutation {
  auth {
    email(email: "$email")
  }
}
"""),
    ),
  );
}
