import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/shared/constants/font_size.dart';
import 'package:shared/widgets/text_widget.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
          title,
          align: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
            fontSize: AppFontSize.semiBig,
          ),
        ),
        if (subtitle != null)
          textWidget(
            subtitle!,
            align: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
              fontSize: AppFontSize.small,
            ),
          ),
        child,
      ],
    );
  }
}
