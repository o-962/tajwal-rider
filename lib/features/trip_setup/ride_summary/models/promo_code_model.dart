import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:shared/utils/index.dart';

class PromoCodeModel {
  final num costDiscounted;
  final num cost;
  final bool ok;

  const PromoCodeModel({
    required this.costDiscounted,
    required this.cost,
    required this.ok,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      costDiscounted: toDouble(json[FieldInputType.COST_DISCOUNTED.value]),
      cost: toDouble(json[FieldInputType.COST.value]) ,
      ok : json['ok'] ?? false
    );
  }

  static toJson(String code) {
    return {
      FieldInputType.CODE.value: code,
    };
  }
}
