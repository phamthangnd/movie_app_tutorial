import 'package:flutter/material.dart';
import 'package:movieapp/common/image_utils.dart';

import '../../common/constants/size_constants.dart';
import '../../common/extensions/size_extensions.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_32.w, vertical: Sizes.dimen_32.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 96.0,
            width: 96.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: const Color(0xFFF7F8FA), width: 0.6),
              image: DecorationImage(
                image: ImageUtils.getAssetImage('pngs/im_empty_listing'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Text(
            "Chưa có bản ghi",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
