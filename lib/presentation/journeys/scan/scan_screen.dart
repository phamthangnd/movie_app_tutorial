import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/common/constants/size_constants.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/di/get_it.dart';
import 'package:movieapp/presentation/blocs/save_result/save_result_cubit.dart';
import 'package:movieapp/presentation/journeys/loading/loading_circle.dart';
import 'package:movieapp/presentation/journeys/scan/qrcode_reader_view.dart';
import 'package:movieapp/presentation/widgets/app_error_widget.dart';

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
          if (state is SaveResultError)
            alert(state.errorType.toString());
          if (state is SaveResultSuccess)
            alert(state.record.soCccd!);
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
