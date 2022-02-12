import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/common/constants/translation_constants.dart';
import 'package:movieapp/common/extensions/string_extensions.dart';
import 'package:movieapp/presentation/blocs/home/home_cubit.dart';
import 'package:movieapp/presentation/journeys/account/account_screen.dart';
import 'package:movieapp/presentation/journeys/data/data_screen.dart';
import 'package:movieapp/presentation/journeys/scan/scan_screen.dart';
import 'package:movieapp/presentation/themes/theme_color.dart';

import '../../../di/get_it.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeCubit homeCubit;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    homeCubit = getItInstance<HomeCubit>();
    _pages = [
      AccountScreen(),
      ScanScreen(),
      DataScreen(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    homeCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => homeCubit,
        ),
      ],
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            // drawer: const NavigationDrawer(),
            body: IndexedStack(
              index: currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey[200],
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  activeIcon: const Icon(Icons.account_circle, color: AppColor.violet),
                  icon: const Icon(Icons.account_circle_outlined),
                  label: TranslationConstants.account.t(context),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.qr_code_2_outlined),
                  activeIcon: const Icon(Icons.qr_code, color: AppColor.violet,),
                  label: TranslationConstants.scan.t(context),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.data_usage),
                  activeIcon: const Icon(Icons.data_usage_outlined,color: AppColor.violet),
                  label: TranslationConstants.data.t(context),
                ),
              ],
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<HomeCubit>().pageChanged(index);
              },
            ),
          );
        },
      ),
    );
  }
}
