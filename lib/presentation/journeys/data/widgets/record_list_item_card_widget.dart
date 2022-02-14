import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/common/image_utils.dart';

import '../../../../common/constants/size_constants.dart';
import '../../../../common/extensions/size_extensions.dart';
import '../../../../common/extensions/string_extensions.dart';
import '../../../../data/core/api_constants.dart';

class RecordListItemCardWidget extends StatelessWidget {
  final int recordId;
  final String title, address;

  const RecordListItemCardWidget({
    Key? key,
    required this.recordId,
    required this.title,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(
        //   RouteList.movieDetail,
        //   arguments: MovieDetailArguments(movieId),
        // );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.dimen_8.w),
            child: Container(
              height: 36.0,
              width: 36.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.dimen_8.w),
                border: Border.all(color: const Color(0xFFF7F8FA), width: 0.6),
                image: DecorationImage(
                  image: ImageUtils.getAssetImage('icons/logo'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: Sizes.dimen_4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.intelliTrim(),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    address,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
