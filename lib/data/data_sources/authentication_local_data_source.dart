import 'dart:convert';

import 'package:hive/hive.dart';
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
  @override
  Future<void> deleteSessionId() async {
    print('delete session - local');
    final authenticationBox = await Hive.openBox('authenticationBox');
    authenticationBox.delete('session_id');
  }

  @override
  Future<String?> getToken() async {
    final authenticationBox = await Hive.openBox('authenticationBox');
    return await authenticationBox.get('session_id');
  }

  @override
  Future<void> saveToken(String sessionId) async {
    final authenticationBox = await Hive.openBox('authenticationBox');
    return await authenticationBox.put('session_id', sessionId);
  }

  @override
  Future<LoginResponse?> getLoggedIn() async {
    var pref = await SharedPreferences.getInstance();
    if (pref.getString("logged_in") == null) return null;
    return await jsonDecode(pref.getString('logged_in')!);
  }

  @override
  Future<void> saveLoggedIn(LoginResponse response) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString('logged_in', response.toString());
  }

  @override
  Future<bool> isLoggedIn() async {
    return await getLoggedIn().then((value) => value != null ? true : false);
  }

  @override
  Future<void> deleteLoggedInData() async {
    print('delete loggedIn data - local');
    final authenticationBox = await Hive.openBox('authenticationBox');
    authenticationBox.delete('logged_in');
  }
}
