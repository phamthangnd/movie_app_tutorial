import 'package:flutter/material.dart';
import 'package:movieapp/common/constants/size_constants.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/common/image_utils.dart';

class Logo extends StatelessWidget {
  final double height;

  const Logo({
    Key? key,
    required this.height,
  })   : assert(height > 0, 'height should be greater than 0'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Sizes.dimen_8.w),
      child: Container(
        height: 128.0,
        width: 128.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.dimen_8.w),
          border: Border.all(color: const Color(0xFFF7F8FA), width: 0.6),
          image: DecorationImage(
            image: ImageUtils.getAssetImage('icons/logo'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
