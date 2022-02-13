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
  bool _type = false;
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
              onPressed: () {},
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
                      return ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 16.0),
                        shrinkWrap: true,
                        itemCount: state.records.length,
                        itemExtent: 76.0,
                        itemBuilder: (context, index) {
                          var entity = records[index];
                          return _buildItem(entity);
                        },
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

  Widget _buildItem(RecordEntity entity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: Row(
          children: <Widget>[
            SizedBox(width: Sizes.dimen_4.w),
            Container(
              height: 36.0,
              width: 36.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: const Color(0xFFF7F8FA), width: 0.6),
                image: DecorationImage(
                  image: ImageUtils.getAssetImage('icons/logo'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(width: Sizes.dimen_8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${entity.hoTen} - ${entity.namSinh} - ${entity.gioiTinh}', style: Theme.of(context).textTheme.subtitle2),
                  Text('${entity.diaChi}', style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ),
          ],
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
