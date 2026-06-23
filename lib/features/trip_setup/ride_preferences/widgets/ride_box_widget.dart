import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/widgets/text_widget.dart';

Widget rideBoxWidget({
  required VoidCallback onClick,
  required String text,
  required String image,
  Widget Function()? underElement,
  bool isSelected = false,
  bool disabled = false,
}) {
  return GestureDetector(
    onTap: disabled ? null : onClick,
    child: Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: disabled
              ? Colors.grey[300]
              : isSelected
                  ? AppColor.primary
                  : AppColor.secondary,
        ),
        constraints: BoxConstraints(minWidth: 230, minHeight: 230),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/memojies/$image',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            textWidget(
              text,
              marginVertical: 3,
              style: TextStyle(
                color: disabled
                    ? Colors.grey[600]
                    : isSelected
                        ? AppColor.white
                        : AppColor.primary,
              ),
            ),
            if (underElement != null) underElement(),
          ],
        ),
      ),
    ),
  );
}
