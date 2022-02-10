import 'package:flutter/material.dart';

import '../common/constants/route_constants.dart';
import 'journeys/home/home_screen.dart';
import 'journeys/login/login_screen.dart';
import 'journeys/splash/splash_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => SplashScreen(),
        RouteList.login: (context) => LoginScreen(),
        RouteList.home: (context) => HomeScreen(),
      };
}
