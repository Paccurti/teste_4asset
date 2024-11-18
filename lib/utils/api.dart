import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const bool enabledHttps = true;
const String urlServer = 'dev-api-plt.4asset.net.br';

class Api {
  static Future<Response> doRequest(String path, String method,
      dynamic body, dynamic headers) async {
    Uri uriServer =
        enabledHttps ? Uri.https(urlServer, path) : Uri.https(urlServer, path);

    late Future<Response> response;
    switch (method.toUpperCase()) {
      case 'GET':
        response = http
            .get(uriServer,
                headers: headers ??
                    {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json'
                    })
            .timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException(
              'The connection has timed out, Please try again!');
        });
        break;
      case 'POST':
        response = http
            .post(uriServer,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json'
                },
                body: body)
            .timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException(
              'The connection has timed out, Please try again!');
        });
        break;
      case 'PATCH':
        response = http
            .patch(uriServer,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json'
                },
                body: body)
            .timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException(
              'The connection has timed out, Please try again!');
        });
        break;
      case 'DELETE':
        response = http.delete(uriServer, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }).timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException(
              'The connection has timed out, Please try again!');
        });
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }

    return response;
  }
}
