import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';

class GiftsOrderModel {
  Set<FieldInputType> fields = {
    FieldInputType.PICKUP_LAT,
    FieldInputType.PICKUP_LNG,
    FieldInputType.DROPOFF_LAT,
    FieldInputType.DROPOFF_LNG,
    FieldInputType.SCHEDULED_AT,
    FieldInputType.TYPE,
    FieldInputType.SIZE,
    FieldInputType.RECIPIENT_NAME,
    FieldInputType.RECIPIENT_PHONE,
    FieldInputType.IMAGE,
  };
  // pickup location
  double pickupLat = 32.341794534443714;
  double pickupLng = 36.193570706623845;

  // dropoff location
  double dropLat = 31.988561609496085;
  double dropLng = 35.943894973424925;

  // gift details
  GiftType type = GiftType.NORMAL;
  GiftSize size = GiftSize.SMALL;
  String recipientName = '';
  String recipientPhone = '';

  /// Local file of the gift photo the rider attached.
  File? image;

  /// Chosen departure date & time, picked from the slot sheet.
  DateTime? scheduledAt;

  /// Multipart payload for `POST /orders/gifts` (the image is a file part).
  Future<FormData> toFormData({String? discountCode}) async {
    return FormData.fromMap({
      FieldInputType.PICKUP_LAT.value: pickupLat,
      FieldInputType.PICKUP_LNG.value: pickupLng,
      FieldInputType.DROPOFF_LAT.value: dropLat,
      FieldInputType.DROPOFF_LNG.value: dropLng,
      FieldInputType.SCHEDULED_AT.value: scheduledAt?.toIso8601String(),
      FieldInputType.TYPE.value: type.value,
      FieldInputType.SIZE.value: size.value,
      FieldInputType.RECIPIENT_NAME.value: recipientName,
      FieldInputType.RECIPIENT_PHONE.value: recipientPhone,
      if (discountCode != null) FieldInputType.DISCOUNT_CODE.value: discountCode,
      if (image != null)
        FieldInputType.IMAGE.value: await MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split(Platform.pathSeparator).last,
        ),
    });
  }

  /// JSON body for `POST /orders/gifts/summary`.
  ///
  /// Only the fields pricing actually reads — the photo and recipient details
  /// don't affect the quote, so a summary never costs the rider an upload.
  Map<String, dynamic> toSummaryJson({String? discountCode}) {
    return {
      FieldInputType.PICKUP_LAT.value: pickupLat,
      FieldInputType.PICKUP_LNG.value: pickupLng,
      FieldInputType.DROPOFF_LAT.value: dropLat,
      FieldInputType.DROPOFF_LNG.value: dropLng,
      FieldInputType.SCHEDULED_AT.value: scheduledAt?.toIso8601String(),
      FieldInputType.TYPE.value: type.value,
      FieldInputType.SIZE.value: size.value,
      if (discountCode != null) FieldInputType.DISCOUNT_CODE.value: discountCode,
    };
  }
}
