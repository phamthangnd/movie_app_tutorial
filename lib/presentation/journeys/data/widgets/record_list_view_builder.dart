import 'package:flutter/material.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import '../../../../common/constants/size_constants.dart';
import '../../../../common/extensions/size_extensions.dart';

import 'record_list_item_card_widget.dart';

class RecordListViewBuilder extends StatelessWidget {
  final List<RecordEntity> movies;

  const RecordListViewBuilder({Key? key, required this.movies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h),
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(top: Sizes.dimen_6.h),
        shrinkWrap: true,
        // itemExtent: 76.0,
        itemCount: movies.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: Sizes.dimen_14.h,
          );
        },
        itemBuilder: (context, index) {
          final RecordEntity movie = movies[index];
          return RecordListItemCardWidget(
            recordId: movie.id!,
            title: '${movie.hoTen} - ${movie.namSinh} - ${movie.gioiTinh}',
            address: movie.diaChi!,
          );
        },
      ),
    );
  }
}
