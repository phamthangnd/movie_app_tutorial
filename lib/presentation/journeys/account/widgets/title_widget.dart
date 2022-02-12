import 'package:flutter/material.dart';

import '../../../../common/constants/size_constants.dart';
import '../../../../common/extensions/size_extensions.dart';
import '../../../../common/extensions/string_extensions.dart';
import '../../../themes/theme_color.dart';
import '../../../themes/theme_text.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final IconData? icon;

  const TitleWidget({
    Key? key,
    required this.title,
    this.icon,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isSelected ? AppColor.royalBlue : Colors.transparent,
            width: Sizes.dimen_1.h,
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          // title.t(context), //'popular', 'now', 'soon'
          style: isSelected ? Theme.of(context).textTheme.royalBlueSubtitle1 : Theme.of(context).textTheme.subtitle1,
        ),
        leading: Icon(icon ?? Icons.hourglass_empty),
      ),
    );
  }
}
