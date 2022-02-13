import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/common/constants/size_constants.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/di/get_it.dart';
import 'package:movieapp/presentation/blocs/account/get_account_cubit.dart';
import 'package:movieapp/presentation/journeys/account/widgets/title_widget.dart';
import 'package:movieapp/presentation/journeys/loading/loading_circle.dart';
import 'package:movieapp/presentation/themes/theme_text.dart';
import 'package:movieapp/presentation/widgets/app_error_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late GetAccountCubit getAccountCubit;

  @override
  void initState() {
    super.initState();
    getAccountCubit = getItInstance<GetAccountCubit>();
    getAccountCubit.loadAccountInfo();
  }

  @override
  void dispose() {
    super.dispose();
    getAccountCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetAccountCubit>(
      create: (context) => getAccountCubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<GetAccountCubit, GetAccountState>(
            builder: (context, state) {
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.dimen_16.w,
                  vertical: Sizes.dimen_20.h,
                ),
                children: [
                  if (state is GetAccountLoaded)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Thông tin',
                            // title.t(context), //'popular', 'now', 'soon'
                            style: Theme.of(context).textTheme.royalBlueSubtitle1,
                          ),
                        ),
                        TitleWidget(
                          title: state.accountInfo.name ?? '',
                          icon: Icons.person,
                        ),
                        TitleWidget(
                          title: state.accountInfo.email ?? '',
                          icon: Icons.email,
                        ),
                        TitleWidget(
                          title: state.accountInfo.phoneNumber ?? '',
                          icon: Icons.smartphone,
                        ),
                        TitleWidget(
                          title: state.accountInfo.address ?? '',
                          icon: Icons.location_city,
                        ),
                      ],
                    ),
                  if (state is GetAccountError)
                    Container(
                      child: AppErrorWidget(
                        errorType: state.errorType,
                        onPressed: () => getAccountCubit.loadAccountInfo(),
                      ),
                    ),
                  if (state is GetAccountLoading)
                    Container(
                      child: Center(
                        child: LoadingCircle(
                          size: Sizes.dimen_100.w,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
