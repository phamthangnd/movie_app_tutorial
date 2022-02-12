import 'dart:convert';
import 'package:movieapp/data/models/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationLocalDataSource {
  Future<void> saveToken(String sessionId);
  Future<void> saveLoggedIn(LoginResponse sessionId);
  Future<String?> getToken();
  Future<LoginResponse?> getLoggedIn();
  Future<void> deleteSessionId();
  Future<void> deleteLoggedInData();
  Future<bool> isLoggedIn();
}

class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {

  static const String tokenKey = 'token';
  static const String loginResponseKey = 'logged_in';

  @override
  Future<void> deleteSessionId() async {
    print('delete session - local');
    var pref = await SharedPreferences.getInstance();
    pref.remove(tokenKey);
  }

  @override
  Future<String?> getToken() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString(tokenKey);
  }

  @override
  Future<void> saveToken(String sessionId) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(tokenKey, sessionId);
  }

  @override
  Future<LoginResponse?> getLoggedIn() async {
    var pref = await SharedPreferences.getInstance();
    if (pref.getString(loginResponseKey) == null) return null;
    return await LoginResponse.fromJson(jsonDecode(pref.getString(loginResponseKey)!));
  }

  @override
  Future<void> saveLoggedIn(LoginResponse response) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(loginResponseKey, jsonEncode(response));
  }

  @override
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? loginData = prefs.getString(loginResponseKey);
    if (loginData == null || loginData.isEmpty) return false;

    final Map<String, dynamic> data = jsonDecode(loginData);
    if (!data.containsKey(tokenKey) || '${data[tokenKey]}'.isEmpty) {
      return false;
    }
    final String? token = data[tokenKey];
    final bool isLoggedIn = token != null && token.isNotEmpty;
    return isLoggedIn;
  }

  @override
  Future<void> deleteLoggedInData() async {
    print('delete loggedIn data - local');
    var pref = await SharedPreferences.getInstance();
    pref.remove(loginResponseKey);
  }
}
