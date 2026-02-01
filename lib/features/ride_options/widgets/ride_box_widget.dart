import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/widgets/text_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

Widget rideBoxWidget({
  required VoidCallback onClick,
  required String text,
  required String image,
  Widget Function()? underElement,
  bool isSelected = false,
}) {
  RideService controller = Get.find<RideService>();
  return GestureDetector(
    onTap: () {
      onClick();
      controller.canSubmit();
      controller.calcCosts();
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? AppColor.primary : AppColor.secondary,
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
              color: isSelected ? AppColor.white : AppColor.primary,
            ),
          ),
          if (underElement != null) underElement(),
        ],
      ),
    ),
  );
}
