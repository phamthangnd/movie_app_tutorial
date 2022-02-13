import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/common/constants/size_constants.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/di/get_it.dart';
import 'package:movieapp/presentation/blocs/save_result/save_result_cubit.dart';
import 'package:movieapp/presentation/journeys/loading/loading_circle.dart';
import 'package:movieapp/presentation/journeys/scan/qrcode_reader_view.dart';
import 'package:movieapp/presentation/themes/theme_color.dart';
import 'package:intl/intl.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late SaveResultCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = getItInstance<SaveResultCubit>();
  }

  @override
  void dispose() {
    super.dispose();
    homeCubit.close();
  }

  void alert(String tip) {
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(tip)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => homeCubit,
      child: BlocConsumer<SaveResultCubit, SaveResultState>(
        listener: (_, state) {
          if (state is SaveResultError) alert(state.errorType.toString());
          if (state is SaveResultSuccess) {
            showDialog(
              context: scaffoldKey.currentContext!,
              builder: (context) {
                final day = state.record.ngayCap!.substring(1, 2);
                final month = state.record.ngayCap!.substring(3, 4);
                final year = state.record.ngayCap!.substring(5, 8);
                var ngayCap = DateFormat("dd/MM/yyyy").format(DateTime(int.parse(year), int.parse(month), int.parse(day)));
                return AlertDialog(
                  title: Text('Thông tin chủ hộ'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Họ tên: ${state.record.hoTen}'),
                      Text('Năm sinh: ${state.record.namSinh}'),
                      Text('Địa chỉ: ${state.record.diaChi}'),
                      Text('Ngày cấp: $ngayCap'),
                    ],
                  ),
                  actions: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: OverflowBar(
                        spacing: 8,
                        overflowAlignment: OverflowBarAlignment.end,
                        children: <Widget>[
                          TextButton(
                              child: Text(
                                'Quét thông tin Vợ/Chồng',
                                style: Theme.of(context).textTheme.button!.copyWith(color: AppColor.royalBlue),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          OutlinedButton(
                              child: Text(
                                'Gửi',
                                style: Theme.of(context).textTheme.button!.copyWith(color: AppColor.violet),
                              ),
                              onPressed: () {
                                //TODO submit data
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ),
                  ],
                ).build(context);
              },
            );
          }
        },
        builder: (context, state) {
          if (state is SaveResultLoading)
            return Container(
              child: Center(
                child: LoadingCircle(
                  size: Sizes.dimen_100.w,
                ),
              ),
            );
          return Scaffold(
            key: scaffoldKey,
            body: QrcodeReaderView(
              onScan: (result) async {
                // alert(result);
                homeCubit.saveDataResultScan(result);
              },
              headerWidget: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
