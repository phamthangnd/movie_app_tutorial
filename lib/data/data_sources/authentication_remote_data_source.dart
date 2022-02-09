import 'package:movieapp/data/models/login_response.dart';

import '../core/api_client.dart';

abstract class AuthenticationRemoteDataSource {
  Future<LoginResponse> login(Map<String, dynamic> requestBody);
  // Future<String?> createSession(Map<String, dynamic> requestBody);
  // Future<bool> deleteSession(String sessionId);
}

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  final ApiClient _client;

  AuthenticationRemoteDataSourceImpl(this._client);

  @override
  Future<LoginResponse> login(
      Map<String, dynamic> requestBody) async {
    final response = await _client.post(
      'auth/login',
      params: requestBody,
    );
    print(response);
    return LoginResponse.fromJson(response);
  }
  //
  // @override
  // Future<String?> createSession(Map<String, dynamic> requestBody) async {
  //   final response = await _client.post(
  //     'authentication/session/new',
  //     params: requestBody,
  //   );
  //   print(response);
  //   return response['success'] ? response['session_id'] : null;
  // }

  // @override
  // Future<bool> deleteSession(String sessionId) async {
  //   final response = await _client.deleteWithBody(
  //     'authentication/session',
  //     params: {
  //       'session_id': sessionId,
  //     },
  //   );
  //   return response['success'] ?? false;
  // }
}
