import 'package:flutter/material.dart';
import 'package:movieapp/presentation/themes/theme_color.dart';

class SelectedDateButton extends StatelessWidget {

  const SelectedDateButton(this.text,{
    Key? key,
    this.fontSize = 14.0,
    this.selected = false,
    required this.unSelectedTextColor,
    this.enable = true,
    this.onTap,
    this.semanticsLabel
  }): super(key: key);

  final String text;
  final double fontSize;
  final bool selected;
  final Color unSelectedTextColor;
  final GestureTapCallback? onTap;
  final bool enable;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    Widget child = _buildText();
    
    if (enable) {
      child = InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: fontSize > 14 ? double.infinity : 32.0, // 日历按钮32 * 32
            minWidth: 32.0,
            maxHeight: 32.0,
            minHeight: 32.0,
          ),
          padding: EdgeInsets.symmetric(horizontal: fontSize > 14 ? 10.0 : 0.0),
          decoration: selected ? BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(color: AppColor.shadow_blue, offset: Offset(0.0, 2.0), blurRadius: 8.0),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF5758FA), AppColor.gradient_blue],
            ),
          ) : null,
          alignment: Alignment.center,
          child: child,
        ),
      );
    }
    
    return child;
  }

  Widget _buildText() {
    if (text.startsWith('Tháng') || text.startsWith('Ngày')) {
      return RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: text.substring(0, text.length - 1), style: TextStyle(color: getTextColor(), fontSize: fontSize)),
            TextSpan(text: text.substring(text.length - 1), style: TextStyle(color: getTextColor(), fontSize: fontSize - 4.0)),
          ],
        ),
      );
    } else {
      return Text(text,
        semanticsLabel: semanticsLabel,
        style: TextStyle(color: getTextColor(), fontSize: fontSize),
      );
    }
  }

  Color getTextColor() {
    return enable ? (selected ? Colors.white : unSelectedTextColor) : AppColor.vulcan;
  }
}
