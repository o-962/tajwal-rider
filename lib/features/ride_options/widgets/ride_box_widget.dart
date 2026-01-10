import 'package:flutter/material.dart';
import 'package:shared/common/colors.dart';
import 'package:tajwal_rider/features/ride_options/controllers/ride_options_controller.dart';
import 'package:tajwal_rider/services/ride_services.dart';
import 'package:shared/widgets/text_widget.dart';

Widget rideBoxWidget({ required VoidCallback onClick, required String text, required String image, Widget Function()? underElement, bool isSelected = false, }) {

  return GestureDetector(
    onTap: (){
      onClick();
      RideServices.canSubmit();
      RideOptionsController().calcCosts();
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? AppColor.primary : AppColor.secondary,
      ),
      constraints: BoxConstraints(
        minWidth: 230,
        minHeight: 230
      ),
      padding: EdgeInsets.all(20),
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
          textWidget(text, marginVertical: 3 , style: TextStyle(color: isSelected ? AppColor.white : AppColor.primary)),
          if (underElement != null) underElement(),
        ],
      ),
    ),
  );
}