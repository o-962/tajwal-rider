import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/shared/constants/font_size.dart';
import 'package:shared/shared/constants/layout.dart';
import 'package:shared/widgets/text_widget.dart';
import 'package:tajwal_rider/utils/ride_utils.dart';

class RideLocationBoxWidget extends StatelessWidget {
  final String hintText;

  final RxList<dynamic> placesList = <dynamic>[].obs;
  final void Function(String title, double lat, double lng) onLocTap;
  final TextEditingController textController;

  RideLocationBoxWidget({
    super.key,
    required this.hintText,
    required this.onLocTap,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    Timer? debounce;
    return Positioned(
      top: 0,
      left: 0,
      width: AppSize.width,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 64, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Field
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                    width: 44,
                    height: 44,
                    
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  onTap: () => Get.toNamed('/settings'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: TextField(
                          controller: textController,
                          onChanged: (value) async {
                            if (debounce?.isActive ?? false) debounce!.cancel();

                            debounce = Timer(
                              const Duration(milliseconds: 500),
                              () async {
                                if (value.isNotEmpty) {
                                  placesList.value =
                                      await getNearbyPlacesWithDetails(value);
                                } else {
                                  placesList.clear();
                                }
                              },
                            );
                          },
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Obx(() {
                if (placesList.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: placesList
                      .map(
                        (place) => _locationTile(
                          place['name'],
                          place['lat'],
                          place['lng'],
                        ),
                      )
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationTile(String title, double lat, double lng) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: () {
          onLocTap(title, lat, lng);
          placesList.clear();
        },
        child: ListTile(
          leading: const Icon(Icons.location_on, color: Colors.white),
          title: textWidget(
            title,
            align: TextAlign.start,
            style: TextStyle(color: Colors.white, fontSize: AppFontSize.tiny),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 16,
          ),
        ),
      ),
    );
  }
}
