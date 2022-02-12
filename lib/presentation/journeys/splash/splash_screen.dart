import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/common/constants/route_constants.dart';
import 'package:movieapp/common/constants/size_constants.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/di/get_it.dart';
import 'package:movieapp/presentation/blocs/authentication/auth_cubit.dart';
import 'package:movieapp/presentation/journeys/home/home_screen.dart';
import 'package:movieapp/presentation/journeys/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = getItInstance<AuthCubit>();
    // WidgetsBinding.instance!.addPostFrameCallback((_) => authCubit.checkAuthenticate());
  }

  @override
  void dispose() {
    super.dispose();
    authCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState.isSignedIn) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
