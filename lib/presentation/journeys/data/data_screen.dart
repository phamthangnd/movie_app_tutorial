import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' hide context;
import 'package:path/path.dart' as path;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/common/constants/size_constants.dart';
import 'package:movieapp/common/date_util.dart';
import 'package:movieapp/common/date_utils.dart' as date;
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/common/image_utils.dart';
import 'package:movieapp/di/get_it.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import 'package:movieapp/presentation/blocs/get_record/get_record_cubit.dart';
import 'package:movieapp/presentation/journeys/loading/loading_circle.dart';
import 'package:movieapp/presentation/themes/theme_color.dart';
import 'package:movieapp/presentation/widgets/app_empty_widget.dart';
import 'package:movieapp/presentation/widgets/app_error_widget.dart';
import 'package:movieapp/presentation/widgets/load_image.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/record_list_view_builder.dart';
import 'widgets/selected_date.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  late List<RecordEntity> records;
  late GetRecordCubit getRecordCubit;
  late DateTime _initialDay;
  int _selectedIndex = 2;
  late Iterable<DateTime> _weeksDays;
  late List<DateTime> _currentMonthsDays;
  late int _selectedWeekDay;
  late DateTime _selectedDay;
  late int _selectedMonth;
  final List<int> _monthList = [];
  bool _isExpanded = true;
  late Color _unSelectedTextColor = AppColor.vulcan;

  static const List<String> _weeks = ['T2, T3, T4, T5, T6, T7, CN'];

  @override
  void initState() {
    super.initState();
    _initialDay = DateTime.now();
    _selectedWeekDay = _initialDay.day;
    _selectedDay = _initialDay;
    _selectedMonth = _initialDay.month;
    _weeksDays = date.DateUtils.daysInRange(date.DateUtils.previousWeek(_initialDay), date.DateUtils.nextDay(_initialDay))
        .toList()
        .sublist(1, 8);
    _currentMonthsDays = date.DateUtils.daysInMonth(_initialDay);
    _monthList.clear();
    for (int i = 1; i < 13; i++) {
      _monthList.add(i);
    }
    getRecordCubit = getItInstance<GetRecordCubit>();
    getRecordCubit.getListResultScan(dateTime: _selectedDay);
    records = <RecordEntity>[];
  }

  @override
  void dispose() {
    super.dispose();
    getRecordCubit.close();
  }

  void exportData(List<RecordEntity> list) async {
    Stopwatch stopwatch = new Stopwatch()..start();
    Excel excel = Excel.createExcel();
    Sheet sh = excel['Data'];
    ///HEADER
    // for (int i = 0; i < 9; i++) {
    //   sh.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value = 'Col $i';
    // }
    /*
    [
    {id : 1, soCccd : "564565436546", soCmnd : "123242342", diaChi : "Xóm 21, Thọ Nghiệp, Xuân Trường, Nam Định", ngayCap : "02072021", hoTen : "Phạm Văn Thắng", namSinh : "1989", gioiTinh : "Nam"},
    {id : 2, soCccd : "436546346456", soCmnd : "465645436", diaChi : "Xóm 21, Thọ Nghiệp, Xuân Trường, Nam Định", ngayCap : "02072021", hoTen : "Phạm Văn Thắng", namSinh : "1989", gioiTinh : "Nam"},
    ]
    */
    var rows = list.length;
    for (int row = 0; row < rows; row++) {
      var entity = list[row]; // entity
      Map<String, dynamic> mapEntity = entity.toMap();
      var reversed = Map.fromEntries(mapEntity.entries.map((e) => MapEntry(e.key, e.value)));
      var _col = 0;
      for (var kv in reversed.entries) {
        sh.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: _col)).value = kv.value;
        _col++;
      }
    }
    print('Generating executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    var onValue = excel.encode();
    print('Encoding executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    if(appDocDir == null){
      throw UnimplementedError(
          'getApplicationSupportPath() has not been implemented.');
    }
    String appDocPath = appDocDir.path;
    String dbPath = path.join(appDocPath, "${DateTime.now().toIso8601String()}.xlsx");
    File(dbPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
    print('Exported file in ${stopwatch.elapsed}');
  }

  @override
  Widget build(BuildContext context) {
    _unSelectedTextColor = AppColor.vulcan;
    return BlocProvider<GetRecordCubit>(
      create: (context) => getRecordCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            date.stringifyMonthOfDate() ?? 'Dữ liệu',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: AppColor.royalBlue),
          ),
          actions: [
            IconButton(
              onPressed: (records.isNotEmpty) ? () => exportData(records) : null,
              icon: Icon(Icons.save_alt, color: AppColor.vulcan),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          key: const Key('record_statistics_list'),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: Sizes.dimen_12.h),
                Flexible(
                  child: Container(
                    // color: AppColor.bg_gray,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: _selectedIndex != 1 ? 4.0 : 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AnimatedSize(
                          curve: Curves.decelerate,
                          duration: const Duration(milliseconds: 300),
                          child: _buildCalendar(),
                        ),
                        if (_selectedIndex == 1)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Semantics(
                              label: _isExpanded ? 'Rút gọn' : 'Mở rộng',
                              child: Container(
                                height: 27.0,
                                alignment: Alignment.topCenter,
                                child: LoadAssetImage(
                                  'icons/${_isExpanded ? 'up' : 'down'}',
                                  width: 16.0,
                                  color: AppColor.dark_text,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: Sizes.dimen_16.h),
                Text('Hôm nay - ${date.stringifyDate()}',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: AppColor.vulcan)),
                SizedBox(width: Sizes.dimen_16.h),
                BlocConsumer<GetRecordCubit, GetRecordState>(
                  listener: (context, state) {
                    if (state is GetRecordSuccess && state.records.length > 0) {
                      setState(() {
                        records.addAll(state.records);
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is GetRecordSuccess) {
                      if (state.records.isEmpty) {
                        return AppEmptyWidget();
                      }
                      return RecordListViewBuilder(
                        movies: state.records,
                      );
                    }
                    if (state is GetRecordError) {
                      return AppErrorWidget(
                        errorType: state.errorType,
                        onPressed: () => getRecordCubit.getListResultScan(dateTime: _selectedDay),
                      );
                    }
                    if (state is GetRecordLoading)
                      Center(
                        child: LoadingCircle(
                          size: Sizes.dimen_100.w,
                        ),
                      );
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    List<Widget> children = [];
    if (_selectedIndex == 0) {
      children = _builderYearCalendar();
    } else if (_selectedIndex == 1) {
      children = _builderMonthCalendar();
    } else if (_selectedIndex == 2) {
      children = _builderWeekCalendar();
    }

    return GridView.count(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 7,
      children: children,
    );
  }

  List<Widget> _buildWeeks() {
    final List<Widget> widgets = [];
    void addWidget(String str) {
      widgets.add(Center(
        child: Text(str, style: Theme.of(context).textTheme.subtitle2),
      ));
    }

    _weeks.forEach(addWidget);
    return widgets;
  }

  List<Widget> _builderMonthCalendar() {
    final List<Widget> dayWidgets = [];
    List<DateTime> list;
    if (_isExpanded) {
      list = _currentMonthsDays;
    } else {
      list = date.DateUtils.daysInWeek(_selectedDay);
    }
    dayWidgets.addAll(_buildWeeks());

    void addButton(DateTime day) {
      dayWidgets.add(
        Center(
          child: SelectedDateButton(
            day.day.toString().padLeft(2, '0'), // 不足2位左边补0
            selected: day.day == _selectedDay.day && !date.DateUtils.isExtraDay(day, _initialDay),
            // 不是本月的日期与超过当前日期的不可点击
            enable: day.day <= _initialDay.day && !date.DateUtils.isExtraDay(day, _initialDay),
            unSelectedTextColor: _unSelectedTextColor,

            /// 日历中的具体日期添加完整语义
            semanticsLabel: DateUtil.formatDate(day, format: DateFormats.vi_y_mo_d),
            onTap: () {
              setState(() {
                _selectedDay = day;
              });
            },
          ),
        ),
      );
    }

    list.forEach(addButton);
    return dayWidgets;
  }

  List<Widget> _builderYearCalendar() {
    final List<Widget> monthWidgets = [];
    void addButton(int month) {
      monthWidgets.add(
        Center(
          child: SelectedDateButton(
            'Tháng $month',
            selected: month == _selectedMonth,
            enable: month <= _initialDay.month,
            unSelectedTextColor: _unSelectedTextColor,
            onTap: () {
              setState(() {
                _selectedMonth = month;
              });
            },
          ),
        ),
      );
    }

    _monthList.forEach(addButton);
    return monthWidgets;
  }

  List<Widget> _builderWeekCalendar() {
    final List<Widget> dayWidgets = [];
    void addButton(DateTime day) {
      dayWidgets.add(
        Center(
          child: SelectedDateButton(
            day.day.toString().padLeft(2, '0'),
            selected: day.day == _selectedWeekDay,
            unSelectedTextColor: _unSelectedTextColor,
            semanticsLabel: DateUtil.formatDate(day, format: DateFormats.vi_y_mo_d),
            onTap: () {
              setState(() {
                _selectedWeekDay = day.day;
                getRecordCubit.getListResultScan(dateTime: day);
                // context.read<GetRecordCubit>().getListRecord(_selectedDay);
              });
            },
          ),
        ),
      );
    }

    _weeksDays.forEach(addButton);
    return dayWidgets;
  }
}
